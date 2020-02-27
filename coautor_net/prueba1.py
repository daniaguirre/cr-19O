import dblp
autores = dblp.search('michael ley')
print autores.size
print autores.__class__
print autores
print autores.dtypes
print autores.lin
print autores_df.set_index('Authors',inplace=True)
#michael = autores[0]
#pint michael.name
#print len(michael.publications)