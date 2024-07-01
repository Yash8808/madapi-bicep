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

@description('Service principal client secret')
param clientSecret string

@description('SSH public key for the Linux nodes')
param sshPublicKey string

resource aksCluster 'Microsoft.ContainerService/managedClusters@2022-02-01' = {
  name: aksClusterName
  location: location
  properties: {
    kubernetesVersion: kubernetesVersion
    dnsPrefix: aksClusterName
    agentPoolProfiles: [
      {
        name: nodePoolName
        count: agentCount
        vmSize: vmSize
        maxPods: 110
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: adminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshPublicKey
          }
        ]
      }
    }
    servicePrincipalProfile: {
      clientId: clientId
      secret: clientSecret
    }
    networkProfile: {
      networkPlugin: 'azure'
      loadBalancerSku: 'standard'
      outboundType: 'loadBalancer'
    }
    enableRBAC: true
  }
}

output kubeConfig string = aksCluster.properties.fqdn
