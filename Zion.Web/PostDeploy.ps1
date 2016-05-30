# Transform Angular Config and replace existing

rm Scripts\app\common\common-config.js
mv Scripts\app\common\common-config.template.js Scripts\app\common\common-config.js

$webConfig = 'Web.config'
[Xml]$config = (Get-Content $webConfig)

$wsFederation = $config.configuration.'system.identityModel.services'.federationConfiguration.wsFederation
$wsFederation.issuer = $STSIssuer;
$wsFederation.reply = $STSReply;
$wsFederation.realm = $STSRealm;
$config.Save($webConfig)
