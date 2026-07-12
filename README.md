# Lesson 8–9: CI/CD для Django в Amazon EKS за допомогою Terraform, Jenkins, Helm та Argo CD

## Опис проєкту

Цей проєкт реалізує повний **GitOps CI/CD pipeline** для Django-застосунку, який розгортається в Amazon EKS.

Уся AWS-інфраструктура створюється через Terraform.

CI/CD процес побудований за схемою:

```
Developer
    |
    | git push
    |
    v
 Jenkins Pipeline
    |
    | build image
    |
    v
 Kaniko
    |
    | push image
    |
    v
 Amazon ECR
    |
    | update Helm values
    |
    v
 Git Helm Repository
    |
    | sync
    |
    v
 Argo CD
    |
    v
 Amazon EKS
```

---

# Використані технології

## Infrastructure

* **Terraform** — Infrastructure as Code.
* **Amazon VPC** — мережа для Kubernetes та баз даних.
* **Amazon EKS** — Kubernetes кластер.
* **Amazon ECR** — Docker registry.
* **Amazon S3 + DynamoDB** — Terraform remote backend.
* **Amazon RDS / Aurora** — база даних застосунку.

---

## CI/CD

* **Jenkins** — автоматизація pipeline.
* **Kubernetes Agent** — запуск Jenkins pipeline всередині EKS.
* **Kaniko** — Docker image build без Docker daemon.
* **Helm** — Kubernetes package manager.
* **Argo CD** — GitOps deployment controller.

---

# Структура проєкту

```
Project/
│
├── main.tf
├── backend.tf
├── outputs.tf
│
├── modules/
│   │
│   ├── s3-backend/
│   │   ├── s3.tf
│   │   ├── dynamodb.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── vpc/
│   │   ├── vpc.tf
│   │   ├── routes.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── ecr/
│   │   ├── ecr.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── eks/
│   │   ├── eks.tf
│   │   ├── aws_ebs_csi_driver.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── rds/
│   │   ├── rds.tf
│   │   ├── aurora.tf
│   │   ├── shared.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   │
│   ├── jenkins/
│   │   ├── jenkins.tf
│   │   ├── providers.tf
│   │   ├── values.yaml
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── argo_cd/
│       ├── argo_cd.tf
│       ├── providers.tf
│       ├── values.yaml
│       ├── variables.tf
│       ├── outputs.tf
│       └── charts/
│           ├── Chart.yaml
│           ├── values.yaml
│           └── templates/
│               ├── application.yaml
│               └── repository.yaml
│
├── charts/
│   └── django-app/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── configmap.yaml
│           ├── secret.yaml
│           └── hpa.yaml
│
└── Jenkinsfile
```

---

# Terraform Infrastructure

Terraform створює:

## Networking

* VPC;
* Public subnet;
* Private subnet;
* Internet Gateway;
* Route tables.

---

## Kubernetes

Створюється:

* Amazon EKS Cluster;
* Managed Node Groups;
* AWS EBS CSI Driver.

---

## Container Registry

Створюється:

* Amazon ECR Repository.

ECR використовується для зберігання Docker images Django застосунку.

---

# Database Module (RDS)

Модуль `rds` підтримує два режими роботи:

## Aurora

При:

```hcl
use_aurora = true
```

створюється:

* Aurora Cluster;
* Writer Instance;
* Cluster Parameter Group;
* DB Subnet Group;
* Security Group.

Приклад:

```hcl
engine = "aurora-postgresql"
engine_version = "15.4"
instance_class = "db.r6g.large"
```

---

## Standard RDS

При:

```hcl
use_aurora = false
```

створюється:

* AWS RDS Instance;
* DB Parameter Group;
* DB Subnet Group;
* Security Group.

Приклад:

```hcl
engine = "postgres"
engine_version = "15.4"
instance_class = "db.t3.medium"
```

---

# Terraform Backend

Terraform state зберігається у:

```
Amazon S3
```

Locking виконується через:

```
Amazon DynamoDB
```

Приклад:

```hcl
backend "s3" {
  bucket = "terraform-state"
  key    = "eks/terraform.tfstate"
  region = "eu-central-1"

  dynamodb_table = "terraform-lock"
}
```

---

# Jenkins CI Pipeline

Pipeline знаходиться у:

```
Jenkinsfile
```

Етапи:

## 1. Checkout

Отримання вихідного коду Django.

---

## 2. Docker Build

Збірка image виконується через:

```
Kaniko
```

без Docker daemon.

---

## 3. Push Image

Image публікується у:

```
Amazon ECR
```

---

## 4. Update Helm Chart

Jenkins змінює:

```
charts/django-app/values.yaml
```

Наприклад:

```yaml
image:
  repository:
    xxx.dkr.ecr.eu-central-1.amazonaws.com/django-app

  tag:
    build-25
```


## 5. Git Push

Оновлений Helm chart відправляється у Git repository.


# Kubernetes Agent

Jenkins pipeline запускається всередині Kubernetes Pod.

Pod містить:

## Kaniko container

Використовується для:

* Docker image build;
* push у ECR.


## Git container

Використовується для:

* clone Helm repository;
* commit;
* push змін.

# Helm Charts

Helm використовується для:

## Jenkins

Встановлення Jenkins у Kubernetes.

## Argo CD

Встановлення Argo CD.

## Django Application

Chart:

```
charts/django-app
```

містить:

* Deployment;
* Service;
* ConfigMap;
* Secret;
* Horizontal Pod Autoscaler.

# Argo CD GitOps

Argo CD контролює стан Kubernetes через Git repository.

Application налаштована з:

```yaml
syncPolicy:
  automated:
    prune: true
    selfHeal: true
```

Після зміни Helm chart:

1. Jenkins робить commit.
2. Argo CD знаходить новий commit.
3. Argo CD виконує sync.
4. Kubernetes оновлює Deployment.
5. Новий Docker image запускається в EKS.


# Deployment

## 1. Terraform initialization

```bash
terraform init
```


## 2. Infrastructure deployment

```bash
terraform apply -auto-approve
```

Terraform створить:

* VPC;
* EKS;
* ECR;
* RDS/Aurora;
* Jenkins;
* Argo CD.


## 3. Configure Kubernetes

Отримати kubeconfig:

```bash
aws eks update-kubeconfig \
--name <cluster-name> \
--region <region>
```

Перевірка:

```bash
kubectl get nodes
```

# CI/CD Result

Після виконання проєкту отримуємо повністю автоматизований процес:

✅ Terraform створює AWS Infrastructure
✅ EKS запускає Kubernetes Cluster
✅ Jenkins автоматично збирає Django image
✅ Kaniko публікує image у ECR
✅ Jenkins оновлює Helm chart
✅ Git зберігає desired state
✅ Argo CD автоматично деплоїть нову версію
✅ Django працює у Amazon EKS


# Summary

Проєкт реалізує сучасний production-підхід:

* Infrastructure as Code через Terraform;
* Kubernetes orchestration через Amazon EKS;
* CI через Jenkins;
* Container registry через Amazon ECR;
* CD через Argo CD;
* GitOps workflow;
* автоматичне масштабування Django через Kubernetes HPA.

Цей підхід дозволяє повністю автоматизувати життєвий цикл Django-застосунку від commit до production deployment.
