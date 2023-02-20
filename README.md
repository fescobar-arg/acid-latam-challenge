## Acid labs - LATAM - SRE Challenge

Como aclaracion, reutilice el codigo que realizaron para generar los resultados del modelo, dado que el archivo pickle_model.pkl no me devolvia mas que un pequeño string sin informacion relevante cuando extraia el contenido. Una vez cargado el codigo y ejecutado con la parte de regresion logistica, pude generar el output con los resultados de la prediccion obtenida del modelo, los cuales seran utilizados por la API y seran expuestos en formato JSON.

La aplicacion esta dockerizada para que sea mas facil ejecutarla desde cualquier equipo, pero lo recomendable es que se ejecute con sistema operativo linux. La API utiliza el framework de python FastAPI y solo posee una funcion GET (/load_model) que permitira exponer los resultados mencionados anteriormente.
Por otro lado, elegi el cloud provider Azure para levantar la aplicacion, ya que tengo creditos en mi cuenta para generar los recursos necesarios, en este caso utilizando el servicio de container instances para correr la aplicacion en contenedores docker. Por lo tanto, el codigo de terraform permitira levantar la aplicacion, utilizando el cloud provider mencionado, que luego podra accederse mediante su IP publica por el puerto tcp 80. 

**A continuacion se detallan los pasos necesarios y requerimientos para correr el codigo en terraform y levantar la aplicacion:**

**Requerimientos:**
Se debe contar con los siguientes programas instalados en la PC que corra los comandos de terraform:

 - Docker 		---> https://docs.docker.com/engine/install/
 - Terraform 	---> https://developer.hashicorp.com/terraform/downloads

En los links de cada uno de los programas seleccionar los que correspondan a su sistema operativo.

**Pasos para correr la aplicacion:**

En primer lugar se debe descargar el contenido del repositorio de git. 
Para ello se puede utilizar descargar desde la misma web de git o bien corriendo el siguiente comando:

    git clone https://github.com/fescobar-arg/Acid-Latam-Challenge.git

Una vez descargados los archivos se deben modificar los valores asignados a las variables de terraform que son utilizadas para indicarles nuestros datos para hacer login a la subscripcion de Azure. Para ello se debe modificar el archivo "terraform.tfvars" y ajustar las variables:

    > app_name          = "latamchallengefastapiapp"
    resource_group_name = "latamChallenge-resource-group"
    location            = "eastus"
    client_id           = "AZURE_CLIENT_ID"
    client_secret       = "AZURE_CLIENT_SECRET"
    tenant_id           = "AZURE_TENANT_ID"
    subscription_id     = "AZURE_SUBSCRIPTION_ID"
   
 Una vez que indicamos nuestro client_id; client_secret; tenant_id y subscription_id terraform va a poder conectarse a la cuenta de Azure.
 Luego, debemos correr los siguientes comandos de terraform para crear los recursos y correr nuestra API:
 

    terraform init
    terraform plan
    terraform apply -auto-approve

En el proceso de la ejecucion de terraform, se va a generar la imagen de docker a partir del Dockerfile existente en el repsositorio que luego sera publicado en el container registry de Azure. Por lo que es normal que el proceso pueda demorar unos 10 minutos aproximadamente para terminar. Una vez que finaliza la ejecucion del comando de terraform, nos devuelve en un output la URL con la ip publica para acceder a nuestra api, tal como se ve en el siguiente ejemplo:

![enter image description here](https://i.ibb.co/X4ybwgQ/tfoutput.png)
La URL nos dara acceso a la UI de FastAPI, donde podremos seleccionar la funcion GET /load_model y ejecutarla para que nos devuelva el JSON con los resultados de la prediccion:

![enter image description here](https://i.ibb.co/X8Nvqsq/fastapi.png)

Por ultimo, si queremos eliminar los recursos que fueron generados con terraform, podemos correr el comando "terraform destroy" y confirmar la destruccion de los recursos.
