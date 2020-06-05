if (-not(([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"`
    ))) {
    Write-Output "管理者権限がありません"
    exit $false
}


add-type -assembly System.Windows.Forms

function run($ports, $wsl2_ip){
    $ip = "0.0.0.0"
    $ports_a = $ports -join ","
    # [System.Windows.Forms.MessageBox]::Show("a${wsl2_ip}a", "タイトル")
    # Remove-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock'
    # New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort $ports_a -Action Allow -Protocol TCP
    # New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Inbound -LocalPort $ports_a -Action Allow -Protocol TCP
    netsh interface portproxy reset
    foreach($port in $ports){
        # netsh interface portproxy delete v4tov4 listenport=${port} listenaddress=${ip}
        netsh interface portproxy add v4tov4 listenport=${port} listenaddress=${ip} connectport=${port} connectaddress=${wsl2_ip}
    }
}


$Form = New-Object System.Windows.Forms.Form
$Form.text = "WSL2 ポートフォワーディング設定ツール"

$form_width = 316
$form_margin = 32
$Form.size = [string]($form_width + 2 * $form_margin + 16) + ", 390"

$Label1 = New-Object System.Windows.Forms.Label
$wsl2_ip = wsl -- hostname -I
$wsl2_ip = $wsl2_ip.trim()

$font = "UD デジタル 教科書体 N-B"

$Label1.text = "WSL2 IPアドレス: ${wsl2_ip}"
$Label1.font = "$font, 14"
$Label1.width = $form_width
$Label1.location = New-Object System.Drawing.Point($form_margin, $form_margin)
$Form.controls.add($Label1)

########################
$ip_list = [system.net.dns]::GetHostAddresses((hostname)) | where { $_.AddressFamily -eq "InterNetwork" } | select -ExpandProperty IPAddressToString
$Label2 = New-Object System.Windows.Forms.Label
$Label2.text = "ローカルIPアドレス: ${ip_list}"
$Label2.font = "$font, 14"
$Label2.width = $form_width
$top = ($form_margin + 32)
$Label2.location = New-Object System.Drawing.Point($form_margin, $top)
$Form.controls.add($Label2)

########################
$top += 32
$ListBox1 = New-Object System.Windows.Forms.ListBox
$ListBox1.Location = New-Object System.Drawing.Point($form_margin, $top)
$ListBox1.width = $form_width
$Form.controls.add($ListBox1)
$ListBox1.Font = "$font, 14"
$ListBox1.Height = 128
$ListBox1.Items.Add(80)

########################
$top += 128

$Label3 = New-Object System.Windows.Forms.Label
$Label3.text = "ポート番号"
$Label3.font = "$font, 14"
$Label3.Width = ($form_width / 3)
$Label3.location = New-Object System.Drawing.Point($form_margin, $top)
$Form.controls.add($Label3)

$TextBox1 = New-Object System.Windows.Forms.TextBox
$TextBox1.Location = New-Object System.Drawing.Point(($form_margin + $Label3.Width + 16), $top)
$TextBox1.Font = "$font, 14"
$TextBox1.Height = 32
$TextBox1.Width = ($form_width / 3)
$Form.controls.add($TextBox1)

$Button1 = New-Object System.Windows.Forms.Button
$Button1.Location = New-Object System.Drawing.Point(($form_margin + $Label3.Width + $TextBox1.Width + 32), $top)
$TextBox1.Width = ($form_width / 3)
$Button1.Font = "$font, 14"
$Button1.Text = "追加"
$Button1.Height = $form_margin
$Form.controls.add($Button1)
$Button1.add_click({
    if(!($TextBox1.Text -eq "")){
        if($ListBox1.Items.IndexOf([int]$TextBox1.Text) -eq -1){
            # [System.Windows.Forms.MessageBox]::Show("OK", "タイトル") 
            $ListBox1.Items.Add([int]$TextBox1.Text)
        }
    }
})

########################
$top += 40
$Button2 = New-Object System.Windows.Forms.Button
$Button2.Location = New-Object System.Drawing.Point($form_margin, $top)
$Button2.width = $form_width
$Button2.Font = "$font, 14"
$Button2.Text = "削除"
$Button2.Height = 32
$Form.controls.add($Button2)
$Button2.add_click({
    $ListBox1.Items.Remove($ListBox1.SelectedItem)
})

########################
$top += 40
$Button3 = New-Object System.Windows.Forms.Button
$Button3.Location = New-Object System.Drawing.Point($form_margin, $top)
$Button3.width = $form_width
$Button3.Font = "$font, 14"
$Button3.Text = "設定"
$Button3.Height = 32
$Form.controls.add($Button3)
$Button3.add_click({
    $ports = @()
    foreach($port in $ListBox1.Items){
        $ports += $port
    }
    run $ports $wsl2_ip
})

$Form.showdialog()
