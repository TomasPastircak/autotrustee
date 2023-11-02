### Tohle je potřeba vyplnit (až po nějaký řádek 12)
### Kde se nachazi DLL
[Reflection.Assembly]::LoadFile("C:\imapx.dll")
#Adresa mailu, který má být vyplněn v Heliosu
$piratskyMail = "Jmeno.Prijmeni@pirati.cz"
#Uživatelské jméno mailu pro autotrustee skript 
$user = "example@gmail.com"
#IMAP heslo mailu pro autotrustee
$password = "heslo"
#key.txt je název souboru s klíčem.
$key = Get-Content -Path key.txt

$client = New-Object ImapX.ImapClient

$client.Behavior.MessageFetchMode = "Full"
#Konfigurace IMAP klienta - při použití gmailu není potřeba měnit.
$client.Host = "imap.gmail.com"
$client.Port = 993
$client.UseSsl = $true

### Odsud už to jede samo
function Get-TimeStamp {
    
    return "[{0:dd/MM/yy} {0:HH:mm:ss}]" -f (Get-Date)
    
}

while($true){
	Write-Output "$(Get-TimeStamp) Běžím..." | Tee-Object -Filepath ./log.txt -append
	if (-not ($client.IsConnected)){
		$client.Connect()
		$client.Login($user,$password)
	}
	$messages = $client.Folders.Inbox.Search("ALL", $client.Behavior.MessageFetchMode, 1000)

	foreach($m in $messages){
		#$m.Subject
		if ($m.Subject -like '*your trustee homepage*') {
		#Restrictive regex in case someone tries to expose the PK.
			$regex = "https://helios.pirati.cz/helios/t/[^\s]+/"+$piratskyMail+"/[a-zA-Z0-9]+"
			$m.Body.Text -match $regex
			$url = $matches[0]
			$url
			
			$ie = New-Object -COM 'InternetExplorer.Application'
			#$ie.Visible = $true
			$ie.Navigate($url);
			
			while($ie.ReadyState -ne 4) {start-sleep -m 100} 
			
			$node = $ie.document.getElementsByTagName('a') | Where-Object {$_.href -match "keygenerator"} 
			if ($node -ne $null){
				Write-Output "$(Get-TimeStamp) Uploaduju klíč před hlasováním na url $url" | Tee-Object -Filepath ./log.txt -append
				$node.click()
				start-sleep -m 100
				$node = $ie.document.getElementsByTagName('a') | Where-Object {$_.href -match "show_key_reuse"} 
				$node.click()
				start-sleep -m 100
				$node = $ie.document.getElementsByTagName('textarea') | Where-Object {$_.name -match "secret_key"}
				
				$node.innerHTML = $key
				start-sleep -m 100
				$node = $ie.document.getElementsByTagName('input') | Where-Object {$_.value -match "opětovně použít"} 
				$node.click()
				start-sleep -m 100
				$node = $ie.document.getElementsByTagName('input') | Where-Object {$_.value -match "Nahrát veřejný klíč"} 
				$node.click()
				while($ie.ReadyState -ne 4) {start-sleep -m 100} 
				start-sleep -m 5000
			}
			else 
			{
				$node = $ie.document.getElementsByTagName('a') | Where-Object {$_.href -match "decrypt-and-prove"} 
				if ($node -ne $null){
					Write-Output "$(Get-TimeStamp) Uploaduju klíč po hlasování na url $url" | Tee-Object -Filepath ./log.txt -append
					
					$node.click()
					while($ie.ReadyState -ne 4) {start-sleep -m 100} 
					start-sleep -m 1000
					$node = $ie.document.getElementsByTagName('textarea') | Where-Object {$_.id -eq "sk_textarea"}
					$node.innerHTML = $key
					$node = $ie.document.getElementsByTagName('button') | Where-Object {$_.innerHTML -match "Provést částečné dešifrování"}
					$node.click()
					start-sleep -m 5000
					$node = $ie.document.getElementsByTagName('button') | Where-Object {$_.innerHTML -match "Nahrát výsledek dešifrování na server"}
					$node.click()
					start-sleep -m 5000
				} 
				else 
				{
					Write-Output "$(Get-TimeStamp) Našel jsem mail, ale nemůžu v něm nic dělat. Url $url" | Tee-Object -Filepath ./log.txt -append
					$m.Remove()
				}
			}
			$ie.quit()
		}
		else 
		{
			Write-Output "$(Get-TimeStamp) Došel mail co se netýká trustees. Mažu. Předmět $m.subject" | Tee-Object -Filepath ./log.txt -append
			$m.Remove()
		}
	}
	start-sleep -m 60000
}