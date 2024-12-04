
# Kubernetes Infrastructure Provisioning with Terraform and Ansible

Este repositório contém scripts e configurações para provisionar e configurar infraestrutura no Kubernetes utilizando **Terraform** e **Ansible**. O objetivo deste projeto é automatizar a criação de clusters Kubernetes e a instalação de aplicações em um ambiente de nuvem.

## Tecnologias Utilizadas

- **Terraform**: para provisionamento e gerenciamento da infraestrutura de nuvem (como VPCs, sub-redes, instâncias EC2, etc.).
- **Ansible**: para configuração e gerenciamento do Kubernetes e suas aplicações.
- **Kubernetes**: como plataforma de gerenciamento de containers.
- **Cloud Provider**: AWS (ou qualquer outro provedor de sua escolha).

## Estrutura do Repositório

```
.
├── terraform/
│   ├── ec2.tf              # Definição de instancias EC2.
│   ├── variables.tf        # Definição das variáveis do Terraform.
│   ├── outputs.tf          # Definições de saídas do Terraform.
│   ├── providers.tf        # Configuração dos provedores, como AWS, Google Cloud, etc.
│   ├── vpc/                # Módulo reutilizáveis do Terraform para vpc.
│   ├── vpn/                # Módulo reutilizáveis do Terraform para vpn.
├── ansible/
│   ├── playbooks/          # Playbooks para configurar e gerenciar Kubernetes e suas aplicações.
│   ├── inventories/        # Inventários de hosts para o Ansible.
│   ├── roles/              # Funções do Ansible para tarefas repetíveis.
├── README.md               # Este arquivo.
└── .gitignore              # Arquivos a serem ignorados pelo Git.
```

## Pré-requisitos

1. **Terraform**: Certifique-se de que o Terraform está instalado na sua máquina. Você pode instalar o Terraform seguindo as instruções oficiais: [Terraform Install](https://www.terraform.io/downloads.html).

2. **Ansible**: Instale o Ansible utilizando o comando:
   ```bash
   pip install ansible
   ```
   Ou, se estiver usando o sistema baseado em Debian/Ubuntu:
   ```bash
   sudo apt-get install ansible
   ```

3. **Acesso ao Provedor de Nuvem**: O projeto foi desenvolvido para AWS, mas pode ser adaptado para outros provedores. Certifique-se de ter credenciais válidas configuradas no seu ambiente para o provedor de nuvem escolhido.

## Como Usar

### 1. Provisionamento da Infraestrutura com Terraform

- Inicialize o Terraform e aplique a configuração para provisionar os recursos:
  ```bash
  make tf-create
  ```

- Deletar recursos:
  ```bash
  tf-delete
  ```

Após o Terraform concluir, você terá sua infraestrutura provisionada, incluindo a configuração do cluster Kubernetes e recursos necessários.

### 2. Configuração e Gerenciamento com Ansible

- Navegue até o diretório `ansible`:
  ```bash
  cd ansible
  ```

- Certifique-se de que os inventários e playbooks do Ansible estão configurados para os seus nós.

- Execute o playbook para configurar o Kubernetes:
  ```bash
  ansible-playbook -i inventories/inventory.ini playbooks/playbook.yml -vvvv
  ```

- Você pode também usar outros playbooks para instalar aplicações específicas em seu cluster Kubernetes.

## Personalização

- **Variáveis de Terraform**: As variáveis do Terraform são definidas no arquivo `variables.tf`. Você pode personalizar a infraestrutura alterando os valores das variáveis.

- **Playbooks do Ansible**: O diretório `ansible/playbooks/` contém diversos playbooks que podem ser ajustados conforme necessário para instalar e configurar diferentes componentes no Kubernetes, como NGINX, Helm, ou Prometheus.

## Contribuições

Sinta-se à vontade para contribuir com melhorias, correções ou novas funcionalidades. Para isso, siga as etapas abaixo:

1. Fork este repositório.
2. Crie uma nova branch (`git checkout -b feature/nova-feature`).
3. Faça as alterações necessárias.
4. Faça commit (`git commit -am 'Adiciona nova feature'`).
5. Envie a branch para o seu repositório (`git push origin feature/nova-feature`).
6. Abra um Pull Request para o repositório principal.

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).