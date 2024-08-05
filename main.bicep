@description('Name of the AKS cluster')
param aksClusterName string

@description('Location for the AKS cluster')
param location string = resourceGroup().location

@description('Kubernetes version')
param kubernetesVersion string = '1.28.9'

@description('Name of the node pool')
param nodePoolName string = 'default'

@description('VM size for the nodes')
param vmSize string = 'Standard_B2s'

@description('Number of agent nodes')
param agentCount int = 1

@description('Admin username for the Linux nodes')
param adminUsername string = 'azureuser'

@description('Service principal client ID')
param clientId string

@secure()
@description('Service principal client secret')
param clientSecret string

@description('SSH public key for the Linux nodes')
param sshPublicKey string

module aksModule 'aks.bicep' = {
  name: 'aksDeployment'
  params: {
    aksClusterName: aksClusterName
    location: location
    kubernetesVersion: kubernetesVersion
    nodePoolName: nodePoolName
    vmSize: vmSize
    agentCount: agentCount
    adminUsername: adminUsername
    clientId: clientId
    clientSecret: clientSecret
    sshPublicKey: sshPublicKey
  }
}

output kubeConfig string = aksModule.outputs.kubeConfig
