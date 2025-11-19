<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
    xmlns:ns0="www.boltrics.nl/stockstatus:v1.00">
  <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
  <!--<xsl:strip-space elements="*" />-->
  <xsl:template match="/">
    <xsl:variable name="spaces">
      <xsl:value-of select="concat('                                ','')" />
    </xsl:variable>
    <xsl:variable name="zeros">
      <xsl:value-of select="'0000000000'" />
    </xsl:variable>
    <xsl:for-each select="//ns0:Item">
      <xsl:if test="ns0:Attribute04 != ''">
        <xsl:value-of select="concat(ns0:ExternalNo,substring($spaces,1,18-string-length(ns0:ExternalNo)))"/>
        <xsl:value-of select="concat(substring($zeros,1,7-string-length(ns0:QtyInInventory)), ns0:QtyInInventory)" />
        <xsl:value-of select="concat('DS    ', '0000000000000000000000000000DS  ')"/>
        <xsl:value-of select="MyScript:GetCurrentDate('yyyyMMdd')" />
        <xsl:text>&#10;</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>


  <!--<xsl:value-of select="MyScript:Replace(current(), MyScript:PrintApos(), concat('?', MyScript:PrintApos()))" />-->
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			
      public string Replace(string input, string toReplace, string replaceTo)
			{
				return input.Replace(toReplace,replaceTo);
			}
      
      public string PrintApos()
			{
				return ((Char)8217).ToString();
			}
      
  			public string GetCurrentDate(string formatOut)
			{
				return System.DateTime.Now.ToString(formatOut);
			}
		]]>
  </msxsl:script>
</xsl:stylesheet>