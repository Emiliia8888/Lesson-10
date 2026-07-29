pipeline {

    agent {
        kubernetes {
            inheritFrom 'kaniko'
        }
    }

    environment {

        AWS_REGION = "eu-central-1"

        ECR_REPOSITORY = "034255117140.dkr.ecr.eu-central-1.amazonaws.com/django-app-gitops"

        IMAGE_TAG = "${BUILD_NUMBER}"

    }

    stages {

        stage('Checkout Application') {

            steps {

                container('git') {

                    sh '''
                    echo "Using Declarative SCM checkout"

                    ls -la
                    '''

                }

            }

        }

        stage('Validate Project') {

            steps {

                container('git') {

                    sh '''

                    echo "Checking project..."

                    test -f Dockerfile
                    echo "Dockerfile found."

                    test -f requirements.txt
                    echo "requirements.txt found."

                    '''

                }

            }

        }

        stage('Build Docker Image with Kaniko') {

            steps {

                container('kaniko') {

                    sh '''

                    echo "Building image..."

                    /kaniko/executor \
                      --dockerfile=Dockerfile \
                      --context=$WORKSPACE \
                      --destination=${ECR_REPOSITORY}:${IMAGE_TAG}

                    '''

                }

            }

        }

        stage('Update Helm Values') {

            steps {

                container('git') {

                    withCredentials([usernamePassword(
                        credentialsId: 'github-creds',
                        usernameVariable: 'GIT_USERNAME',
                        passwordVariable: 'GIT_PASSWORD'
                    )]) {

                        sh '''

                        echo "Cloning repository for GitOps update"

                        rm -rf gitops-repo

                        git clone https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/Emiliia8888/Lesson-10.git gitops-repo

                        cd gitops-repo

                        echo "Updating image tag..."

                        sed -i "s/^  tag: .*/  tag: ${IMAGE_TAG}/" charts/django-app/values.yaml

                        echo "Current values.yaml:"
                        cat charts/django-app/values.yaml

                        git config user.email "jenkins@localhost"
                        git config user.name "Jenkins"

                        git add charts/django-app/values.yaml

                        git commit -m "Update django image tag to ${IMAGE_TAG}" || echo "No changes"

                        git push origin HEAD:main

                        '''

                    }

                }

            }

        }

    }

    post {

        always {

            container('git') {

                sh '''

                echo "Cleaning workspace permissions"

                chmod -R u+rwX,g+rwX,o+rwX $WORKSPACE || true

                '''

            }

        }

        success {

            echo "Pipeline completed successfully."

        }

        failure {

            echo "Pipeline failed."

        }

    }

}
