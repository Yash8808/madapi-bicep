@description('Name of the AKS cluster')
param aksClusterName string

@description('Location for the AKS cluster')
param location string

@description('Kubernetes version')
param kubernetesVersion string

@description('Name of the node pool')
param nodePoolName string

@description('VM size for the nodes')
param vmSize string

@description('Number of agent nodes')
param agentCount int

@description('Admin username for the Linux nodes')
param adminUsername string

@description('Service principal client ID')
param clientId string

@secure()
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
        osDiskSizeGB: 128
        osDiskType: 'Managed'
        osSKU: 'Ubuntu'
        kubeletDiskType: 'OS'
        powerState: {
          code: 'Running'
        }
        upgradeSettings: {
          maxSurge: '10%'
        }
        enableFIPS: false
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
      ipFamilies: [
        'IPv4'
      ]
      loadBalancerProfile: {
        effectiveOutboundIPs: [
          {}
        ]
      }
      serviceCidrs: [
        '10.0.0.0/16'
      ]
    }
    enableRBAC: true
  }
  sku: {
    name: 'Basic'
    tier: 'Free'
  }
}

output kubeConfig string = aksCluster.properties.fqdn
