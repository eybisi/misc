### Frida Mono
How to use it
```
npm install frida-mono-api
```
Replace node_modules/frida-mono-api and node_modules/frida-ex-nativefunction with my folders.

Compile with `frida-compile`. with Example agent.js

`frida-compile -w.\agent.js -o a.js` (w for watch)

And inject into your game !

`frida "Dealer's Life.exe" -l .\a.js --exit-on-error`




I just babelified modules and used frida-compile. All work goes to [HypnZA](https://twitter.com/HypnZA)

Read his blog [writeup](https://www.hypn.za.net/blog/2020/04/19/hacking-unity-games-part-2-manipulating/)