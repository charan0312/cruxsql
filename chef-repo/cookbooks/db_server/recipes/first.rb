#
# Cookbook Name:: db_server
# Recipe:: first
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

remote_file 'c:\\sql.iso' do
  source 'https://download.microsoft.com/download/4/C/7/4C7D40B9-BCF8-4F8A-9E76-06E9B92FE5AE/ENU/SQLFULL_ENU.iso'
  action :create
end


dsc_script 'Web-Asp-Net45' do
  code <<-EOH
  WindowsFeature InstallDotNet45
  {
    Name = "Web-Asp-Net45"
    Ensure = "Present"
  }
  EOH
end

dsc_script 'Web-Asp-Net35' do
  code <<-EOH
  WindowsFeature InstallDotNet35
  {
    Name = "Net-Framework-core"
    Ensure = "Present"
  }
  EOH
end

file "C:\\Users\\Administrator\\Documents\\script.sql" do
   action :delete
end

remote_file "C:\\Users\\Administrator\\Documents\\sample_db.zip" do
  source 'https://s3-ap-northeast-1.amazonaws.com/swamykonanki/script.zip'
  action :create
end

dsc_script 'Unzip' do
    code <<-EOH
      Archive Download {
        Ensure = "Present"
        Path = "C:\\Users\\Administrator\\Documents\\sample_db.zip"
        Destination = "C:\\Users\\Administrator\\Documents\\"
      }
    EOH
  end

file "C:\\Users\\Administrator\\Documents\\sample_db.zip" do
   action :delete
end

dsc_script 'install-sql-server' do
  code <<-EOH
  Script install-sql-server{
    GetScript = {  }
    SetScript = {
	$passwd = "Rakesh@123"
	$sa_passwd = "Welcome@1234"
  Mount-DiskImage -ImagePath 'c:\\sql.iso'
	D:\\setup.exe /q /ACTION=Install /FEATURES=SQL,Tools /INSTANCENAME=MSSQLSERVER /SECURITYMODE=SQL /SAPWD=$sa_passwd /SQLSVCACCOUNT="Administrator" /SQLSVCPASSWORD=$passwd /SQLSYSADMINACCOUNTS="Administrator" /AGTSVCACCOUNT="NT AUTHORITY\\Network Service" /IACCEPTSQLSERVERLICENSETERMS /UpdateEnabled
    }
    TestScript = {
        $false
  }
}
  EOH
timeout 36000
end
dsc_script 'port' do
  code <<-EOH
    Script portconfiguration
          {

     SetScript = {
               New-NetFirewallRule -DisplayName "SqlServer" -Direction Inbound -LocalPort 1433 -Protocol TCP
            }
           TestScript = {
             $temp =Show-NetFirewallRule | Where-Object {$_.LocalPort -eq 1433}
             if($temp -eq $null)
             {
               $false
             }
             else
             {
               $true
             }
            }
           GETScript = {
            }
          }
EOH
end
