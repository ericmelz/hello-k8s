resource "helm_release" "secrets_store_csi_driver" {
  name       = "secrets-store-csi-driver"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  version    = "1.3.4" # Specify the version as per your requirements

  namespace = "kube-system"

  set {
    name  = "linux.securityContext.runAsUser"
    value = "1001"
  }
}

resource "helm_release" "aws_secretsmanager_csi_driver_provider" {
  name       = "secrets-store-csi-driver-provider-aws"
  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  version    = "0.3.9" # Specify the version as per your requirements

  namespace = "kube-system"

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.csi_secrets_manager_role.arn
  }
}
