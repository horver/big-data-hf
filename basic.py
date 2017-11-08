
# coding: utf-8

# # GTD2 basic notebook

# Spark python könyvtár importálása, majd a spark környezet felállítása

# In[1]:


import pyspark
sc = pyspark.SparkContext()


# Adatok betöltése RDD objektumként, majd egy map segítségével külön választjuk az oszlopokat

# In[2]:


raw = sc.textFile("globalterrorismdb_0617dist.csv")
data = raw.map(lambda x: x.split(';'))


# Saját függvény, amely az adatnak az oszlop indexét adja vissza, az oszlopnév alapján

# In[3]:


def getIndexByKey(key):
    return data.take(1)[0].index(key)


# incidents_in_countries-ba eltároljuk, hogy mennyi az összes rekord egy adott országra nézve
# 
# Várható kimenet:
# 
# országnév | eset db
# --------- | -------
# Japan | 401
# Uruguay | 76
# ... | ...
# 

# In[4]:


country_txt = getIndexByKey('country_txt')
incidents_in_countries = data.map(lambda x: (x[country_txt], 1)).reduceByKey(lambda a,b: a+b)
incidents_in_countries.take(5)

