<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl MyScript" >

  <xsl:output method="xml" indent="yes" />
  
  <xsl:param name="guid" />

  <xsl:template match="/|comment()|processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates select="node()[local-name() = 'Message']"  />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="node()[local-name() = 'MessageID']">
    <xsl:copy>
      <xsl:value-of select="$guid" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"  />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>
</xsl:stylesheet>