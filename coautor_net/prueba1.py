import dblp
autores = dblp.search('D. Aguirre-Guerrero')
#Tamanio
print autores.size
#Tipo de objeto
print autores.__class__
#Contenido de los objetos
print autores
#Nombre de las columnas y tipo de objeto
print autores.dtypes
#pint michael.name
#print len(michael.publications)