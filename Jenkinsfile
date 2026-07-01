pipeline {
  agent any

  options {
    buildDiscarder(logRotator(numToKeepStr: '30', artifactNumToKeepStr: '30'))
    disableConcurrentBuilds()
    skipDefaultCheckout(true)
    timestamps()
    timeout(time: 60, unit: 'MINUTES')
  }

  parameters {
    choice(name: 'TF_WORKSPACE', choices: ['dev', 'qa', 'prod'], description: 'Terraform workspace to select or create.')
    string(name: 'AWS_REGION', defaultValue: 'us-east-1', description: 'AWS region used by Terraform and verification commands.')
    string(name: 'TF_VAR_FILE', defaultValue: 'environments/dev.tfvars', description: 'Terraform variable file for plan/apply.')
    string(name: 'BACKEND_BUCKET', defaultValue: 'ecs-demo-terraform-state-980921723264-us-east-1', description: 'S3 bucket for Terraform remote state.')
    string(name: 'BACKEND_KEY', defaultValue: 'terraform-ecs-fargate-spot/terraform.tfstate', description: 'S3 key for Terraform remote state.')
    booleanParam(name: 'AUTO_APPROVE', defaultValue: false, description: 'Skip manual approval. Keep disabled for production.')
  }

  environment {
    AWS_DEFAULT_REGION = "${params.AWS_REGION}"
    AWS_REGION         = "${params.AWS_REGION}"
    TF_IN_AUTOMATION   = 'true'
    TF_INPUT           = 'false'
    TF_PLAN_FILE       = 'tfplan'
    TF_PLAN_TEXT       = 'tfplan.txt'
    TF_OUTPUT_JSON     = 'terraform-output.json'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Format') {
      steps {
        sh 'terraform fmt -check -recursive -diff'
      }
    }

    stage('Terraform Validate') {
      steps {
        sh '''#!/usr/bin/env bash
          set -euo pipefail
          terraform init -backend=false -input=false
          terraform validate
        '''
      }
    }

    stage('Terraform Init') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-terraform-prod']]) {
          sh '''#!/usr/bin/env bash
            set -euo pipefail
            terraform init \
              -input=false \
              -reconfigure \
              -backend-config="bucket=${BACKEND_BUCKET}" \
              -backend-config="key=${BACKEND_KEY}" \
              -backend-config="region=${AWS_REGION}" \
              -backend-config="encrypt=true" \
              -backend-config="use_lockfile=true"
          '''
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-terraform-prod']]) {
          sh '''#!/usr/bin/env bash
            set -euo pipefail
            terraform workspace select "${TF_WORKSPACE}" || terraform workspace new "${TF_WORKSPACE}"
            terraform plan \
              -input=false \
              -lock=true \
              -lock-timeout=5m \
              -var-file="${TF_VAR_FILE}" \
              -out="${TF_PLAN_FILE}"
            terraform show -no-color "${TF_PLAN_FILE}" | tee "${TF_PLAN_TEXT}"
          '''
        }
      }
    }

    stage('Manual Approval') {
      when {
        expression { !params.AUTO_APPROVE }
      }
      steps {
        script {
          input(
            message: "Apply Terraform plan to workspace '${params.TF_WORKSPACE}' in ${params.AWS_REGION}?",
            ok: 'Apply',
            submitterParameter: 'APPROVED_BY'
          )
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-terraform-prod']]) {
          sh '''#!/usr/bin/env bash
            set -euo pipefail
            terraform apply \
              -input=false \
              -lock=true \
              -lock-timeout=5m \
              -auto-approve \
              "${TF_PLAN_FILE}"
            terraform output -json > "${TF_OUTPUT_JSON}"
          '''
        }
      }
    }

    stage('Verify Bucket') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-terraform-prod']]) {
          sh '''#!/usr/bin/env bash
            set -euo pipefail
            BUCKET_NAME="$(terraform output -raw s3_bucket_name)"
            test -n "${BUCKET_NAME}"
            aws s3api head-bucket --bucket "${BUCKET_NAME}"
            aws s3api get-public-access-block --bucket "${BUCKET_NAME}"
            aws s3api get-bucket-versioning --bucket "${BUCKET_NAME}"
            echo "Verified S3 bucket: ${BUCKET_NAME}"
          '''
        }
      }
    }

    stage('Archive Artifacts') {
      steps {
        archiveArtifacts artifacts: 'tfplan.txt,terraform-output.json', allowEmptyArchive: true, fingerprint: true, onlyIfSuccessful: false
      }
    }

    stage('Cleanup') {
      steps {
        sh '''#!/usr/bin/env bash
          set -euo pipefail
          rm -f "${TF_PLAN_FILE}" "${TF_OUTPUT_JSON}"
          rm -rf .terraform
        '''
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'tfplan.txt,terraform-output.json', allowEmptyArchive: true, fingerprint: true, onlyIfSuccessful: false
    }
    failure {
      echo '''Pipeline failed. Rollback guidance:
1. Do not delete or edit the remote state bucket manually.
2. Review the archived tfplan.txt and Jenkins console output to identify the failed resource.
3. If apply partially succeeded, run a new plan from the same commit, workspace, backend, and tfvars to reconcile state.
4. To roll back an unintended change, revert the Terraform code change and run this pipeline again after approval.
5. Use terraform state commands only for documented drift or import repairs, and back up state before any manual state operation.'''
    }
    aborted {
      echo 'Pipeline aborted before apply or during approval; no rollback is required unless Terraform Apply had already started.'
    }
    cleanup {
      cleanWs(deleteDirs: true, disableDeferredWipeout: true, notFailBuild: true)
    }
  }
}
