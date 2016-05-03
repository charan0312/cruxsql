#
# Cookbook Name:: db_server
# Recipe:: second
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#
# Cookbook Name:: db_server
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#
# Cookbook Name:: sql
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

dsc_script 'install-sql-server' do
  code <<-EOH
  Script install-sql-server{
    GetScript = {  }
    SetScript = {
  #     mkdir c:\\sample
  #   	Import-Module BitsTransfer
	# $url1 = "https://download.microsoft.com/download/4/C/7/4C7D40B9-BCF8-4F8A-9E76-06E9B92FE5AE/ENU/SQLFULL_ENU.iso"
	# $output1 = "C:\\SQLFULL_ENU.iso"
	# $start_time = Get-Date
	# Start-BitsTransfer -Source $url1 -Destination $output1
	# $end_time = Get-Date
  #
  #
	# $passwd = 'fKRLL-t=EE'
	# $sa_passwd = "Welcome@1234"
	# Mount-DiskImage -ImagePath $output1
	# cd D:\
	# .\\setup.exe /q /ACTION=Install /FEATURES=SQL,Tools /INSTANCENAME=MSSQLSERVER /SECURITYMODE=SQL /SAPWD=$sa_passwd /SQLSVCACCOUNT="Administrator" /SQLSVCPASSWORD=$passwd /SQLSYSADMINACCOUNTS="Administrator" /AGTSVCACCOUNT="NT AUTHORITY\Network Service" /IACCEPTSQLSERVERLICENSETERMS /UpdateEnabled /IndicateProgress

	# $env:PSModulePath
	# Set-ExecutionPolicy RemoteSigned -Force


	$script_input = "C:\\Users\\Administrator\\Documents\\sample_db.sql"
	$script_output = "C:\\sqllog.txt"
	Import-Module "C:\\Program Files\\Microsoft SQL Server\\110\\Tools\\PowerShell\\Modules\\SQLPS\S\QLPS.PS1"
	sqlcmd -S $env:USERDOMAIN -U sa -P Welcome@1234 -i $script_path -o $script_output
    }
    TestScript = {

        $false
  }
}
  EOH
end
