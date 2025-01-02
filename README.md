# AWS VPN

A development environment to experiment with the AWS client VPN service

# Guides on AWS VPN with Terraform

- [Creating an AWS Client VPN with Terraform - Timeular](https://timeular.com/blog/creating-an-aws-client-vpn-with-terraform/)
	- [spucman/terraform-aws-client-vpn](https://github.com/spucman/terraform-aws-client-vpn/tree/main)
- [Create a VPN connection to your AWS cluster (Terraform) | by Nikola Sobadjiev | Medium](https://medium.com/@n.sobadjiev_2847/create-a-vpn-connection-to-your-aws-cluster-terraform-deccbfcbfa1d)
- [Get started with AWS Client VPN - AWS Client VPN](https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/cvpn-getting-started.html)

# Having to create own certifiates

For the purposes of POC, we will create a custom certificate authority.
When implementing this work for production, the certificates should come from the company's priavte certicicate authority.
Additionally the certificates might need to be added to the AWS account certificare manager manually and not via IAC.

- [Setting Up Your Own Certificate Authority (CA) | OpenVPN](https://openvpn.net/community-resources/setting-up-your-own-certificate-authority-ca/)
- [OpenVPN/easy-rsa: easy-rsa - Simple shell based CA utility](https://github.com/OpenVPN/easy-rsa)

The main OpenVPN tutorial doesn't explain how to carry out the steps when using Easy RSA. To understand how to use Easy RSA to complete what is required, consult the Easy RSA documentation directly:

- [Enable mutual authentication for AWS Client VPN - AWS Client VPN](https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/client-auth-mutual-enable.html)
  - This one is actually really good
- [easy-rsa/README.quickstart.md at master · OpenVPN/easy-rsa](https://github.com/OpenVPN/easy-rsa/blob/master/README.quickstart.md)
- [easy-rsa/doc/EasyRSA-Readme.md at master · OpenVPN/easy-rsa](https://github.com/OpenVPN/easy-rsa/blob/master/doc/EasyRSA-Readme.md)
- [Using EasyRSA Version 3.x to Generate Certificates for OpenVPN Tunnels – Red Lion Support](https://support.redlion.net/hc/en-us/articles/4403307638797-Using-EasyRSA-Version-3-x-to-Generate-Certificates-for-OpenVPN-Tunnels)

# Required Software

- AWS Cli
- Terraform
- OpenVPN client (official one or AWS VPN client specifically)
- Easy RSA 3 (can be downloaded from GitHub or installed using a package manager)
  - This is to setup our own PKI (public key infrastructure) for the purposes of development

## Notes about Easy RSA on Mac

After installation, the following notes are useful

```
By default, keys will be created in:
  /opt/homebrew/etc/pki

The configuration may be modified by editing and renaming:
  /opt/homebrew/etc/easy-rsa/vars.example
```

# General notes

- Server certificates are valid for a maximum of 825 days.
