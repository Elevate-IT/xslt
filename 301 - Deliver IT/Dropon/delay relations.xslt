<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl MyScript" 
    xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
    xmlns:ns0="www.boltrics.nl/sendtmsdocument:v1.00">
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"  />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="//ns0:Message">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"  />
    </xsl:copy>

    <xsl:value-of select="MyScript:Sleep()" />
  </xsl:template>

  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			

      public void Sleep()
      {
        Threading.Thread.Sleep(30000);
      }

		]]>
  </msxsl:script>
</xsl:stylesheet>
