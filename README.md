# DevOps Environment

### Terraform
O primeiro passo foi pensar na construção do cluster k8s que irá abrigar as duas aplicações. Optei por utilizar o Google Cloud e trabalhar com o Kubernetes Nativo (GKE). Como não estamos abordando questões de VPC, Peering e possíveis overlaps de IP's, optei por utilizar uma rede VPC Default criada pelo próprio Google.
A configuração do cluster foi pensada para ser um mini cluster com máquinas small porém com um autoscaling devidamente configurado (neste pequeno cenário configurei apenas o mínimo 1 e máximo 2 nós).
A criação foi realizada via terraform (v 0.12.30) de forma modularizada com dois módulos ao total: Um para o cluster e outro para o Node Pool. Num cenário real, ambos os módulos estariam em repositórios distintos e poderiam ser reaproveitados em outras demandas. Foi criado um output no módulo do cluster, para que este parâmetro fosse utilizado como dependência na criação do node pool, e também houve a intenção de não expor credenciais ou dados críticos nos arquivos de variáveis.

### Aplicação A
* A primeira aplicação consiste em uma aplicação Python construída com o Flask Framework. Ela faz uma consulta num Bucket S3 e retorna o conteúdo de um arquivo txt armazenado neste bucket. Para seu deploy fiz um push do seu dockerfile para meu repositório no Dockerhub (imagem evandromorini/devops-app-a:latest). No cenário convencional o correto seria armazenar a imagem no Container Registry da Cloud na qual estamos trabalhando.

* Dentro da pasta appA/k8s temos os YAML's para o deploy da aplicação no Cluster Kubernetes. O Deploy ocorre na configuração de Rolling Updates. Pensando numa estratégia de múltiplos ambientes escolhi usar o Kustomize para montar um único arquivo YAML com todas as configurações de determinado ambiente. Ex: Na execução do pipeline poderia direcionar para a pasta do ambiente que eu quero (cd k8s/overlay/staging) e fazer o comando kustomize build . > staging.yaml para gerar o arquivo e após isso aplicar as mudanças com o comando kubectl apply -f

* Para este deploy em específico foi criado um Horizontal Pod Autoscaler para escalar a aplicação quando ela chegar num nível de utilização de 70% da CPU definida no campo de resources do deployment.

* Para testes criei apenas um serviço NodePort pelo qual eu posso testar a aplicação atrás do comando kubectl port-forwarding

* Num cenário real, se fosse uma aplicação acessada externamente poderiamos pensar num load balancer service e também num ingress para a definição do domínio

### Aplicação B
* A segunda aplicação é responsável por fazer uma conexão em um banco relacional MySQL no RDS e devido a isso, foi feita seguindo conceitos mais complexos de desenvolvimento, como divisão em camadas MVC, utilização de ORM, conceitos SOLID, etc. Para seu deploy fiz um push do seu dockerfile para meu repositório no Dockerhub (imagem evandromorini/devops-app-b:latest)

* Com relação aos YAML's do K8s, a única diferença do cenário anterior seria o HPA, que nesta aplicação é acionado baseado no consumo de memória (70%), não mais CPU

* Para testes também foi criado um Service do tipo NodePort que também possibilita o acesso a aplicação através do kubectl port-forwarding

### Pipeline
* Na pasta pipeline foi adicionado um exemplo de CI /CD de uma das aplicações para o ambiente de staging. O pipeline em questão faz o build da imagem, e após efetuar a autenticação no Dockerhub, inclui a tag do ambiente em questão (staging) e realiza o push da imagem. Feito isso, utilizando o SDK do google e o Kustomize, acessamos o cluster e montamos o YAML que será posteriomente aplicado no GKE

## Para testar todo o ambiente se faz necessário após a execução da criação do cluster via terraform:
* Criação dos ambientes(kubectl create namespace staging / kubectl create namespace production)
* Criação do secret devops-app-a-secret com os seguintes parâmetros: AWS_SERVER_PUBLIC_KEY e AWS_SERVER_SECRET_KEY (lembrando que os valores devem ser convertidos em base64 e sem quebra de linhas, exemplo: echo -n 'TESTEDESECRET' | base64)
* Criação do secret devops-app-b-secret com o parâmetro SQLALCHEMY_DATABASE_URI
