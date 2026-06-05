<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="">
  
  <xsl:output method="xml" indent="true" version="1.0" encoding="utf-8"/>
  
  <xsl:variable name="InvoiceNo">
    <xsl:choose>
      <xsl:when test="count(/*:Message/*:PostedCreditInvoices/*:PostedCreditInvoice/*:No) &gt; 0">
        <xsl:value-of select="/*:Message/*:PostedCreditInvoices/*:PostedCreditInvoice/*:No" />
      </xsl:when>
      <xsl:when test="count(/*:Message/*:PostedSalesInvoices/*:PostedSalesInvoice/*:No) &gt; 0">
        <xsl:value-of select="/*:Message/*:PostedSalesInvoices/*:PostedSalesInvoice/*:No" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="//*:No"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="COMPANY">
    <xsl:choose>
      <xsl:when test="starts-with($InvoiceNo, '1')">
        <xsl:text>MARTENS</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>ILS</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!-- Root template -->
  <xsl:template match="/">
    <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                     xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                     xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
      <soap12:Body>
        <AuthenticateUser xmlns="http://websrv.adsolut.be/webservices">
          <userName>Web3</userName>
          <passWord>!Turnhout2300</passWord>
          <database>
            <!-- <xsl:value-of select="$COMPANY" /> -->
            <xsl:text>100003</xsl:text>
          </database>
        </AuthenticateUser>
      </soap12:Body>
    </soap12:Envelope>
  </xsl:template>
  
</xsl:stylesheet>
