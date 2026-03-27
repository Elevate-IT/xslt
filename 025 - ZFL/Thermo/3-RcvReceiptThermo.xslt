<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="msxsl MyScript"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                xmlns:ns0="www.boltrics.nl/receivereceiptthermo:v1.00">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Message | Header | Header/*">
    <xsl:element name="ns0:{local-name()}" namespace="www.boltrics.nl/receivereceiptthermo:v1.00">
      <xsl:apply-templates select="@* | node()" />
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="@*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="DataReceipt">
    <xsl:element name="ns0:Data" namespace="www.boltrics.nl/receivereceiptthermo:v1.00">
      <xsl:apply-templates select="@* | node()" />
    </xsl:element>
    <xsl:value-of select="MyScript:Sleep()" />
  </xsl:template>

  <xsl:template match="DataMMD" />

  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[
      public string GetData(string input, int index)
      {
          return input.Split('|')[index];
      }
      
      public string GetGUID()
      {
        return "{"+Guid.NewGuid().ToString()+"}";
      }   
      
      public string GetCurrentDate(string formatOut)
			{
				return System.DateTime.Now.ToString(formatOut);
			}
      
      public string FormatDate(string input) 
      {
        return input.Substring(0,4) + "-" + input.Substring(4, 2) + "-" + input.Substring(6, 2);
      }
      
      public void Sleep()
      {
        Threading.Thread.Sleep(30000);
      }
    ]]>
  </msxsl:script>
</xsl:stylesheet>
