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
print autores['Authors']
print autores['Link']
print autores['Title']
print autores['Type']
print autores['Where']
print autores['Year']

coautores = autores['Authors']
nombres = set()
for coautor in coautores:
    nombres.update(coautor)
    print nombres
