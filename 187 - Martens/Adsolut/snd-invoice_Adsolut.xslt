<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ns0="www.boltrics.nl/sendpostedsalesinvoice:v1.00"
                xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"
                xmlns:ad="http://websrv.adsolut.be/webservices"
                exclude-result-prefixes="ns0">
  
  <xsl:output method="xml" indent="yes" />
  
  <!-- Root template -->
  <xsl:template match="/">
    <soap12:Envelope>
      <soap12:Body>
        <ad:ImportSalesInvoices>
          <xml>
            <salesinvoices>
              <xsl:apply-templates select="//ns0:PostedSalesInvoice" />
            </salesinvoices>
          </xml>
        </ad:ImportSalesInvoices>
      </soap12:Body>
    </soap12:Envelope>
  </xsl:template>
  
  <!-- One invoice -->
  <xsl:template match="ns0:PostedSalesInvoice">
    <invoice>
      <blrela>
        <!-- Book year: from PostingDate -->
        <boekjaar_boekjaar>
          <xsl:value-of select="substring(ns0:PostingDate,1,4)" />
        </boekjaar_boekjaar>
        
        <dagboek_dagboek>VK</dagboek_dagboek>
        <codefcbd_codefcbd>F</codefcbd_codefcbd>
        
        <!-- Period from PostingDate -->
        <periode_periode>
          <xsl:value-of select="substring(ns0:PostingDate,6,2)" />
        </periode_periode>
        
        <!-- Invoice Number -->
        <factuur>
          <xsl:value-of select="ns0:No"/>
        </factuur>
        
        <!-- Invoice Date -->
        <factdat>
          <xsl:value-of select="ns0:PostingDate"/>
        </factdat>
        
        <!-- Due Date -->
        <vervdat>
          <xsl:value-of select="ns0:DueDate"/>
        </vervdat>
        
        <!-- Customer code -->
        <relaties_code>
          <xsl:value-of select="ns0:Customer/ns0:No"/>
        </relaties_code>
        
        <!-- VAT regime mapping example -->
        <btwregimes_btwregime>
          <xsl:choose>
            <xsl:when test="ns0:VATBusPostingGroup='EU'">H</xsl:when>
            <xsl:otherwise>H</xsl:otherwise>
          </xsl:choose>
        </btwregimes_btwregime>
        
        <!-- Currency -->
        <valuta_code>
          <xsl:value-of select="ns0:CurrencyCode"/>
        </valuta_code>
        
        <koers>1,0</koers>
        
        <!-- Invoice totals -->
        <tebet>
          <xsl:value-of select="format-number(ns0:AmountIncludingVAT, '0.00')" />
        </tebet>
        
        <basis>
          <xsl:value-of select="format-number(ns0:Amount, '0.00')" />
        </basis>
        
        <btwtebet>
          <xsl:value-of select="format-number(ns0:AmountIncludingVAT - ns0:Amount, '0.00')" />
        </btwtebet>
        
        <statusfact_status>OK</statusfact_status>
        <bedragkc>0,00</bedragkc>
        <kortcont>0,00</kortcont>
        <ogm/>
        <omschrijving>
          <xsl:value-of select="ns0:PostingDescription"/>
        </omschrijving>
        <vertegenw_code/>
      </blrela>
      
      <!-- Accounting lines from SalesInvoiceLines -->
      <xsl:apply-templates select="ns0:SalesInvoiceLines/ns0:SalesInvoiceLine" />
    </invoice>
  </xsl:template>
  
  <!-- Line mappings -->
  <xsl:template match="ns0:SalesInvoiceLine">
    <blboekhpl>
      <!-- Date -->
      <datum>
        <xsl:value-of select="../ns0:PostingDate"/>
      </datum>
      
      <!-- Ledger account from General Posting Group -->
      <boekhpl_reknr>
        <xsl:value-of select="ns0:GeneralPostingGroup/ns0:SalesAccount"/>
      </boekhpl_reknr>
      
      <!-- Amount -->
      <bedrag>
        <xsl:value-of select="format-number(ns0:Amount, '0.00')" />
      </bedrag>
      
      <codedc>C</codedc>
      <hoeveelh>
        <xsl:value-of select="format-number(ns0:Quantity, '0.000')" />
      </hoeveelh>
      
      <valuta_code>
        <xsl:value-of select="../../ns0:CurrencyCode"/>
      </valuta_code>
      
      <koers>1,0</koers>
      
      <!-- VAT Regime / Code example -->
      <btwregimes_btwregime>H</btwregimes_btwregime>
      
      <btwcodes_btwcode>
        <xsl:choose>
          <xsl:when test="ns0:VATPercentage='21'">4</xsl:when>
          <xsl:when test="ns0:VATPercentage='0'">0</xsl:when>
          <xsl:otherwise>4</xsl:otherwise>
        </xsl:choose>
      </btwcodes_btwcode>
    </blboekhpl>
  </xsl:template>
  
</xsl:stylesheet>
