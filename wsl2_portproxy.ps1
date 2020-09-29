if (-not(([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"`
    ))) {
    Write-Output "管理者権限がありません"
    exit $false
}

add-type -assembly System.Windows.Forms
add-type -assembly System.Drawing
Set-Alias -name new -value New-Object

function addp($port, $wsl2_ip){
    $ip = "0.0.0.0"
    netsh interface portproxy add v4tov4 listenport=${port} listenaddress=${ip} connectport=${port} connectaddress=${wsl2_ip}
}

function rmp($port){
    $ip = "0.0.0.0"
    netsh interface portproxy delete v4tov4 listenport=${port} listenaddress=${ip}
}

$Form = new System.Windows.Forms.Form
$Form.text = "WSL2 ポートフォワーディング設定ツール"
$form_width = 316
$form_margin = 8

$size = new System.Drawing.Size(350, 270)
$Form.Size = $size

$font = new System.Drawing.Font("Meiryo", 10)

$Label1 = new System.Windows.Forms.Label
$Label1.Font = $font
$wsl2_ip = wsl -- hostname -I; $wsl2_ip = $wsl2_ip.trim()
$Label1.text = "WSL2 IPアドレス: ${wsl2_ip}"
$Label1.width = $form_width
$Label1.location = new System.Drawing.Point($form_margin, $form_margin)
$Form.controls.add($Label1)

$top += 32
$ListBox1 = new System.Windows.Forms.ListBox
$ListBox1.Location = new System.Drawing.Point($form_margin, $top)
$ListBox1.width = $form_width
$Form.controls.add($ListBox1)
$ListBox1.Font = $font
$ListBox1.Height = 128

$portproxy = netsh interface portproxy show all
if($portproxy.count -ne 1){
    foreach($index in 5..($portproxy.count - 2)){
        $list = $portproxy[$index] -split "\s+"
        if($list[2] -ne $wsl2_ip){
            rmp $list[1]
        }else{
            $ListBox1.Items.Add($list[1]) | out-null
        }
    }
}

$top += 128
$rm_port = new System.Windows.Forms.Button
$rm_port.Location = new System.Drawing.Point($form_margin, $top)
$rm_port.Font = $font
$rm_port.Text = new System.String("削除")
$rm_port.Height = 24
$rm_port.Width = $form_width
$Form.controls.add($rm_port)
$rm_port.add_click({
    $port = $ListBox1.SelectedItem
    $ListBox1.Items.Remove($port)
    rmp $port
})

$top += 32
$Label3 = new System.Windows.Forms.Label
$Label3.text = "ポート番号"
$Label3.font = $font
$Label3.Width = ($form_width / 3)
$Label3.location = new System.Drawing.Point($form_margin, $top)
$Form.controls.add($Label3)

$TextBox1 = new System.Windows.Forms.TextBox
$TextBox1.Location = new System.Drawing.Point(($form_margin + $Label3.Width), $top)
$TextBox1.Font = $font
$TextBox1.Height = 32
$TextBox1.Width = ($form_width / 3)
$Form.controls.add($TextBox1)

$Button1 = new System.Windows.Forms.Button
$Button1.Location = new System.Drawing.Point(($form_margin + $Label3.Width + $TextBox1.Width + 24), $top)
$Button1.Font = $font
$Button1.Text = new System.String("追加")
$Button1.Height = 24
$Form.controls.add($Button1)
$Button1.add_click({
    $port = $TextBox1.Text
    $ListBox1.Items.Add($port)
    addp $port $wsl2_ip
})

$Form.showdialog()
