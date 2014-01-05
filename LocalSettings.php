#Debug
$wgDebugLogFile = ""; #/usr/local/mediawiki/debug_log.txt, must be not accessible from outside world.
$wgShowSQLErrors = false;
$wgDebugDumpSql  = false;
$wgShowDBErrorBacktrace = false;
$wgDebugToolbar = false;

#Wikisource
require_once( "$IP/extensions/LabeledSectionTransclusion/lst.php" );
require_once( "$IP/extensions/ProofreadPage/ProofreadPage.php" );
	
$wgFileExtensions[] = 'djvu';
$wgDjvuDump = "djvudump";
$wgDjvuRenderer = "ddjvu";
$wgDjvuTxt = "djvutxt";
$wgDjvuPostProcessor = "ppmtojpeg";
$wgDjvuOutputExtension = 'jpg';

$wgNamespacesToBeSearchedDefault = array(
	NS_MAIN => true,
	250 => true,
	252 => true,
);

