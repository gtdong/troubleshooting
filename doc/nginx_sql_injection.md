## Ngninx防止sql注入配置

### sql语句过滤


   if ($request_uri ~* "(cost()|(concat()") {
                 return 444;
         }
         if ($request_uri ~* "[+|(%20)]union[+|(%20)]") {
                 return 444;
         }
         if ($request_uri ~* "[+|(%20)]and[+|(%20)]") {
                 return 444;
         }
         if ($request_uri ~* "[+|(%20)]select[+|(%20)]") {
                 return 444;
         }
### 文件注入禁止

set $block_file_injections 0;
if ($query_string ~ “[a-zA-Z0-9_]=http://”) {
set $block_file_injections 1;
}
if ($query_string ~ “[a-zA-Z0-9_]=(..//?)+”) {
set $block_file_injections 1;
}
if ($query_string ~ “[a-zA-Z0-9_]=/([a-z0-9_.]//?)+”) {
set $block_file_injections 1;
}
if ($block_file_injections = 1) {
return 444;
}
### 溢出攻击过滤

set $block_common_exploits 0;
if ($query_string ~ “(<|%3C).*script.*(>|%3E)”) {
set $block_common_exploits 1;
}
if ($query_string ~ “GLOBALS(=|[|%[0-9A-Z]{0,2})”) {
set $block_common_exploits 1;
}
if ($query_string ~ “_REQUEST(=|[|%[0-9A-Z]{0,2})”) {
set $block_common_exploits 1;
}
if ($query_string ~ “proc/self/environ”) {
set $block_common_exploits 1;
}
if ($query_string ~ “mosConfig_[a-zA-Z_]{1,21}(=|%3D)”) {
set $block_common_exploits 1;
}
if ($query_string ~ “base64_(en|de)code(.*)”) {
set $block_common_exploits 1;
}
if ($block_common_exploits = 1) {
return 444;
}
### spam字段过滤

set $block_spam 0;
if ($query_string ~ “b(ultram|unicauca|valium|viagra|vicodin|xanax|ypxaieo)b”) {
set $block_spam 1;
}
if ($query_string ~ “b(erections|hoodia|huronriveracres|impotence|levitra|libido)b”) {
set $block_spam 1;
}
if ($query_string ~ “b(ambien|bluespill|cialis|cocaine|ejaculation|erectile)b”) {
set $block_spam 1;
}
if ($query_string ~ “b(lipitor|phentermin|pro[sz]ac|sandyauer|tramadol|troyhamby)b”) {
set $block_spam 1;
}
if ($block_spam = 1) {
return 444;
}
### user-agents头过滤

set $block_user_agents 0;
if ($http_user_agent ~ “Wget”) {
 set $block_user_agents 1;
}
# Disable Akeeba Remote Control 2.5 and earlier
if ($http_user_agent ~ “Indy Library”) {
set $block_user_agents 1;
}
# Common bandwidth hoggers and hacking tools.
if ($http_user_agent ~ “libwww-perl”) {
set $block_user_agents 1;
}
if ($http_user_agent ~ “GetRight”) {
set $block_user_agents 1;
}
if ($http_user_agent ~ “GetWeb!”) {
set $block_user_agents 1;
}
if ($http_user_agent ~ “Go!Zilla”) {
set $block_user_agents 1;
}
if ($http_user_agent ~ “Download Demon”) {
set $block_user_agents 1;
}
if ($http_user_agent ~ “Go-Ahead-Got-It”) {
set $block_user_agents 1;
}
if ($http_user_agent ~ “TurnitinBot”) {
set $block_user_agents 1;
}
if ($http_user_agent ~ “GrabNet”) {
set $block_user_agents 1;
}
if ($block_user_agents = 1) {
return 444;
}
}
注：之所以返回444,是因为其完全不回应客户端，比403或404等更加非常节省系统资源。
