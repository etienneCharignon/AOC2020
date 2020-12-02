Je continue dans la même voie… dans la console.

```
passwords = document.getElementsByTagName('pre')[0].textContent.split('\n')
```

Premier essai :
```
passwords.filter(rullAndPassord => {
  var rull_password = rullAndPassord.split(': ');
	if(!rull_password[1]) { return true; }
	var rull = rull_password[0].split(' ');
	var range = rull[0].split('-');
	var count = rull_password[1].split( '' ).filter( c => c != rull[1] ).length;
	return count < parseInt(range[0]) || count > parseInt(range[1]);
}).length
```

solution première partie :
```
passwords.filter(rullAndPassord => {
  var rull_password = rullAndPassord.split(': ');
	if(!rull_password[1]) { return false; }
	var rull = rull_password[0].split(' ');
	var range = rull[0].split('-').map(r => parseInt(r));
	var count = rull_password[1].split( '' ).filter( c => c == rull[1] ).length;
	//console.log(count, range, count < range[0]);
	return count >= range[0] && count <= range[1];
}).length
```

Solution partie 2 :
```
passwords.filter(rullAndPassord => {
  var rull_password = rullAndPassord.split(': ');
	if(!rull_password[1]) { return false; }
	var rull = rull_password[0].split(' ');
	var range = rull[0].split('-').map(r => parseInt(r)-1);
	var letters = rull_password[1].split( '' );
	//console.log(letters[range[0]], letters[range[1]]);
	return (letters[range[0]] == rull[1] || letters[range[1]] == rull[1]) && letters[range[0]] != letters[range[1]];
}).length
```

Je m'apperçois que je perd un temps fou à ne pas écrire de test. :-)
