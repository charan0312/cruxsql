#
# Cookbook Name:: db_server
# Recipe:: third
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
# dsc_script 'install-sql-server' do
#   code <<-EOH
#   Script install-sql-server{
#     GetScript = {  }
#     SetScript = {
#       Start powershell.exe
#       $env:PSModulePath
# $script_input = "C:\\Users\\Administrator\\Documents\\sample_db.sql"
# $script_output = "C:\\sqllog.txt"
# Import-Module "sqlps" -DisableNameChecking
# sqlcmd -S $env:USERDOMAIN -U sa -P Welcome@1234 -i $script_input -o $script_output
# }
# TestScript = {
#   $false
# }
# }
# EOH
# end

# powershell_script 'write-to-interpolated-path' do
#   code <<-EOH
#   Start powershell.exe '$env:PSModulePath'
# Import-Module "sqlps" -DisableNameChecking
# $script_input = "C:\\Users\\Administrator\\Documents\\sample_db.sql"
# $script_output = "C:\\sqllog.txt"
#
# sqlcmd -S $env:USERDOMAIN -U sa -P Welcome@1234 -i $script_input -o $script_output
#   EOH
# end

powershell_script 'sqlps module' do
  code 'Import-Module "sqlps" -DisableNameChecking'
end

execute 'setup db-maint jobs' do
  command "sqlcmd -S $env:USERDOMAIN -U sa -P Welcome@1234 -i \"C:\\Users\\Administrator\\Documents\\sample_db.sql\" -o \"C:\\sqllog.txt\""
  guard_interpreter :powershell_script
  #not_if "(invoke-sqlcmd -ServerInstance \"localhost\" -Query \"select count(*) from demo.dbo.sysjobs where name like 'DBMaint%'\").Column1 -eq 11"
end
