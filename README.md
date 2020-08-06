[![Linux](https://travis-ci.org/RingsC/Transformer.svg?branch=master "Linux")](https://travis-ci.org/RingsC/Transformer)
# Transformer
A new SQL engine, compatible with ANSI SQL.

By SIMD, GPU and other optimization strategies are incorporated, the performance of operators in execution will be improved. In order to support these optimization, we buid a new SQL database engine, Transformer, which is the project code.
We hope that we can build up a new powerfull DB as Transformer does.

Initialy, The code here is only the framework of the project. We will commit the rest of that in future. 


In future, we want to run the query engine on cloud platform as a service, Query As a Service. The users just only input the sql or some kind of query input specifications,

then the service will produce or ouput the query plan specification or execution plan specification. What you need to do is to specify the storage engine interfaces, 
or access methods.
