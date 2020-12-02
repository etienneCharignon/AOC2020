## directement dans la console du navigateur :

Initialisation :
dépenses = document.getElementsByTagName('pre')[0].textContent.split('\n')

Permière partie :
```
dépenses.forEach(dépense => dépenses.forEach(autreDépense => { if(parseInt(autreDépense) + parseInt(dépense)== 2020) console.log(parseInt(dépense) * parseInt(autreDépense))}))
```

Deuxième partie :
```
dépenses.forEach(dépense => dépenses.forEach(autreDépense => dépenses.forEach(encoreUneAutreDépense => { if(parseInt(autreDépense) + parseInt(dépense) + parseInt(encoreUneAutreDépense) == 2020) console.log(parseInt(dépense) * parseInt(autreDépense) * parseInt(encoreUneAutreDépense))})))
```

