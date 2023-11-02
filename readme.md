Autotrustee je prototyp nástroje umožňující automatické nahrávání klíčů pro pirátské trustees. Prozatím funguje jen na systému Windows. 

Co je potřeba: 
 1) Stáhněte si skript (soubor autotrustee.ps1) a uložte si ho do nějaké složky (třeba c:\autotrustee)
 2) Knihovna ImapX.dll - ke stažení třeba zde: https://www.nuget.org/packages/ImapX (zdroj zde: https://github.com/azanov/imapx )
 3) Vytvořte si novou jednoúčelovou e-mailovou adresu s možností IMAPu přes jméno a heslo (v dalších krocích uvádím adresy přes gmail, ale můžete použít i jinou). Fakt nepoužívejte svůj hlavní mail, skript maže maily, které zprocesoval, proto je potřeba mít opravdu nově vytvořenou jednoúčelovou mailovou schránku. 
 4) Klíč z Heliosu - může být z jakéhokoliv hlasování. Uložte si jej jako key.txt do složky se skriptem. 

Na hlavní mailové adrese (=tam kam vám chodí pirátský mail) si nastavte přeposílání. Níže návod pro gmail:
 5) vpravo nahoře ozubené kolečko - Zobrazit všechna nastavení - Filtry a zablokované adresy - ve filtru nastavte: 
    a) od: helios@pirati.cz
    b) pro: vaše pirátská adresa (=ta, kterou zadává do heliosu ten, kdo vytváří hlasování)
    c) předmět obsahuje "your trustee homepage"
    d) přeposílat na novou adresu (=vytvořenou v kroku 3). Doporučuji nechávat i v "původní" mailové schránce (=pro případy, že by něco nefungovalo). 

Na nově vytvořené adrese (z kroku 3) 
 6) vpravo nahoře ozubené kolečko - Zobrazit všechna nastavení - Přeposílání a protokol POP/IMAP - přístup IMAP - aktivovat
 7) vpravo nahoře "devět teček" - tam Účet - Zabezpečení - Dvoufázové ověření 
    a) zapnout (nejtypičtěji asi s mobilem, na který přijdou zprávy s 2FA) 
    b) v sekci Hesla aplikací si vytvořte nové heslo aplikace (pojmenujte si ji třeba "autotrustee", heslo si schovejte na krok 6 d).


 8) Pokud jste prošli nastavením výše, otevřete si v textovém editoru (např. poznámkový blok nebo Notepad++) soubor autotrustee.ps1 a v něm upravte (správné hodnoty vždy patří do uvozovek): 
    a) 	[Reflection.Assembly]::LoadFile("C:\imapx.dll") - adresa musí vést na uložený soubor z kroku 1), doporučuji do stejné složky, ve které je skript. 
    b) $piratskyMail = "Jmeno.Prijmeni@pirati.cz" - vaše pirátská adresa (viz krok 3) b) )
    c) $user = "example@gmail.com" - vaše nová e-mailová adresa z kroku 2) (pokud nepoužíváte gmail, váš IMAP login)
    d) $password = "heslo" - IMAP heslo vygenerované v kroku 5) b)

 9) Pravým tlačítkem klikněte na soubor autotrustee.ps1 - (na Windows 11 Zobrazit více možností) - Vlastnosti - Důvěřovat tomuto souboru (může to být potřeba i s imapx.dll)
 10) Spusťte powershell (klávesa Windows, pište powershell) a napište příkaz 
cd c:\autotrustee
(kdy c:\autotrustee je složka, v níž je umístěn skript z kroku 1) )
 11) spusťte příkaz .\autotrustee.ps1
 12) nechte si poslat domovskou stránku trusteeho. Pokud je vše nastavené správně, skript nahraje klíč za vás. 