<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="ReportDataSet">
    <xsl:element name="Sales_Invoice_Lines">
      <xsl:apply-templates select="//DataItems[count(DataItem[@name = 'Sales_Invoice_Line']) &gt; 0]" />
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="DataItems[count(DataItem[@name = 'Sales_Invoice_Line']) &gt; 0]">
      <xsl:apply-templates select="DataItem[@name='Sales_Invoice_Line']" />
  </xsl:template>
  
  <xsl:template match="DataItem[@name='Sales_Invoice_Line']">
    <xsl:element name="{./@name}">
      <xsl:element name="No_SalesInvHdr">
        <xsl:value-of select="../../../../../../Columns/Column[@name = 'No_SalesInvHdr']" />
      </xsl:element>
      <!--<xsl:element name="Sell_To_Customer_No">
        <xsl:value-of select="../../../../../..//Columns/Column[@name = 'Sell_To_Customer_No_SalesInvLine'][not(contains(., '-'))]" />
      </xsl:element>-->
      <xsl:apply-templates select="Columns/Column[@name!='']" />
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="DataItem[@name='Sales_Invoice_Line']/Columns/Column">
    <xsl:element name="{./@name}">
      <xsl:value-of select="." />
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>