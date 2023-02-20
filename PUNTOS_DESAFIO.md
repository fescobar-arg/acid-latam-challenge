# Puntos desafio SRE - Acid labs / LATAM

Puntos 1, 2 y 4 comentados en README.md y dentro del repositorio de git se puede encontrar tanto los archivos que interactuan con la app de FastAPI, como los archivos terraform para levantar la aplicacion.

**Punto 3**

A continuacion los resultados obtenidos en la prueba de stress ejecutada con la tool 'wrk' con la aplicacion corriendo en 1 container con 2 cpu y 1GB de RAM:

![enter image description here](https://i.ibb.co/r5PDM9D/benchmark1.png)

**3.a.-** Para mejorar la performance de la aplicacion, lo que puede hacerse en primer instancia es aumentar los recursos de CPU y RAM de la instancia o containers que se encuentran corriendo la aplicacion. Otra alternativa es crear un load balancer con un pool de instancias o containers que permitan autoescalado por consumo y de esa forma obtener un rendimiento consistente en nuestra aplicacion.
Por ejemplo, duplicando los recursos del container que corre la aplicacion, se obtuvo el siguiente resultado:

![enter image description here](https://i.ibb.co/zrGd896/benchmark2.png)

Como podemos ver en la segunda imagen, la latencia paso de 1.21s a 855ms en promedio. Esta disminucion en el tiempo de respuesta hace que incluso, durante el mismo tiempo de ejecucion de la prueba de stress, consigamos una mayor cantidad de requests durante los 45 segundos que dura la ejecucion. Como se evidencia, en el primer ejemplo pudimos realizar 29060 requests con una tasa de 644 req/sec; y en el segundo caso, el total de requests en 45 segundos fue de 41373, a una tasa de 917 req/sec. Es decir, un aumento del 42% en el rendimiento de las pruebas.

Debajo, usando la informacion que obtenemos en el portal de Azure, tambien podemos apreciar que el consumo mayor de los recursos, fue en la CPU:

![enter image description here](https://i.ibb.co/864mrQm/azuremetrics.png)

**Punto 5** 

Para limitar el acceso a los sistemas autorizados a nuestra aplicación API, se puede implementar mecanismos de autenticacion y autorizacion.
Por ejemplo se puede utilizar un mecanismo de autenticacion para verificar la identidad de la aplicacion API. Esto podiía hacerse usando una clave secreta, una combinación de nombre de usuario y contraseña, o un mecanismo de autenticacion utilizando tokens como OAuth. De esta forma, aplicando uno de estos mecanismos logramos garantizar que solo las aplicaciones autorizadas puedan acceder al sistema.
**5.a.-** Estos mecanismos SI impactan en la latencia de la API al consumidor. Por ejemplo, si el mecanismo de autenticacion implica una consulta de base de datos, puede aumentar el tiempo necesario para procesar la solicitud y la respuesta de la API. Lo mismo si el mecanismo de autorizacion involucra alguna regla de control de acceso complejas, puede aumentar el tiempo de procesamiento.
El impacto en la latencia puede ser minimizado implementando la tecnica de autenticacion con tokens OAuth.

**Punto 6**

Si tomamos como referencia para nuestro ejemplo, que la aplicacion va a correr en el servicio de container instances de azure utilizando 1 container que contenga 4 CPU y 2GB de ram, podemos definir los siguientes SLIs y SLOs:

**SLI:**

 - **Latencia promedio:** 900ms
 - **Disponibilidad** 99,99% de uptime
 
 **SLO:**
 - **Latencia promedio:** >300ms
 - **Disponibilidad:** 100% uptime

 Defini esos SLI y SLO tomando en cuenta los resultados obtenidos de la tool 'wrk'. Aunque se pueden definir otros indicadores como la cantidad de fallos en las request que se pueden permitir sobre la api (tomando los HTTP code response por ejemplo, donde evaluariamos los response disintos al HTTP 200).
