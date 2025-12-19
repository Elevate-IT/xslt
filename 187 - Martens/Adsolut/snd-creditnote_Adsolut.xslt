<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ns0="www.boltrics.nl/sendpostedcreditinvoice:v1.00"
                xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:ad="http://websrv.adsolut.be/webservices"
                exclude-result-prefixes="ns0">
  
 <xsl:output method="xml" indent="yes" cdata-section-elements="xml"/>
  
  <xsl:decimal-format name="EU" decimal-separator="," grouping-separator=" "/>

  <!-- Root template -->
  <xsl:template match="/">
    <soap12:Envelope>
      <soap12:Body>
        <ad:ImportSalesInvoices>
          <ad:xml>
            <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
            <salesinvoices>
              <xsl:apply-templates select="//ns0:PostedCreditInvoice" />
            </salesinvoices>
            <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
          </ad:xml>
        </ad:ImportSalesInvoices>
      </soap12:Body>
    </soap12:Envelope>
  </xsl:template>
  
  <!-- One invoice -->
  <xsl:template match="ns0:PostedCreditInvoice">
    <invoice>
      <blrela>
        <boekjaar_boekjaar>
          <xsl:value-of select="substring(ns0:PostingDate,1,4)" />
        </boekjaar_boekjaar>
        
        <dagboek_dagboek>VK</dagboek_dagboek>

        <codefcbd_codefcbd>C</codefcbd_codefcbd>
        
        <periode_periode>
          <xsl:value-of select="substring(ns0:PostingDate,6,2)" />
        </periode_periode>
        
        <factuur>
          <xsl:value-of select="replace(ns0:No, '[^0-9]', '')"/>
        </factuur>
        
        <factdat>
          <xsl:value-of select="ns0:PostingDate"/>
        </factdat>
        
        <vervdat>
          <xsl:value-of select="ns0:DueDate"/>
        </vervdat>
        
        <relaties_code>
          <xsl:choose>
            <xsl:when test="ns0:BillToCustomer/ns0:EANCode != ''">
              <xsl:value-of select="ns0:BillToCustomer/ns0:EANCode"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="ns0:BillToCustomer/ns0:No"/>
            </xsl:otherwise>
          </xsl:choose>
        </relaties_code>
        
        <!-- Optioneel -->
        <!-- <btwregimes_btwregime>
          <xsl:choose>
            <xsl:when test="ns0:VATBusPostingGroup='EU'">H</xsl:when>
            <xsl:otherwise>H</xsl:otherwise>
          </xsl:choose>
        </btwregimes_btwregime> -->
        
        <valuta_code>
          <xsl:choose>
            <xsl:when test="ns0:CurrencyCode != ''">
              <xsl:value-of select="ns0:CurrencyCode"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>EUR</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </valuta_code>
        
        <!-- Optioneel -->
        <!-- <koers>1,0</koers> -->

        <tebet>
          <xsl:value-of select="format-number(ns0:AmountIncludingVAT, '0,00', 'EU')" />
        </tebet>
        
        <basis>
          <xsl:value-of select="format-number(ns0:Amount, '0,00', 'EU')" />
        </basis>
        
        <btwtebet>
          <xsl:value-of select="format-number(ns0:AmountIncludingVAT - ns0:Amount, '0,00', 'EU')" />
        </btwtebet>
        
        <statusfact_status>OK</statusfact_status>

        <!-- <bedragkc></bedragkc> -->
        
        <xsl:if test="count(ns0:PaymentDiscount) &gt; 0">
          <kortcont>
            <xsl:value-of select="format-number(ns0:PaymentDiscount, '0,00', 'EU')" />  
          </kortcont>
        </xsl:if>

        <!-- <ogm/> Overschrijving Gestructureerde Mededeling -->

        <omschrijving>
          <xsl:value-of select="ns0:PostingDescription"/>
        </omschrijving>

        <!-- <vertegenw_code/> -->
      </blrela>
      
      <!-- Accounting lines from SalesInvoiceLines -->
      <xsl:apply-templates select="ns0:PostedCreditInvoiceLines/ns0:PostedCreditInvoiceLine[ns0:Type != '0']" />
    </invoice>
  </xsl:template>
  
  <!-- Line mappings -->
  <xsl:template match="ns0:PostedCreditInvoiceLine">
    <blboekhpl>
      <datum>
        <xsl:value-of select="ns0:PostingDate"/>
      </datum>
      
      <!-- Ledger account from General Posting Group -->
      <boekhpl_reknr>
        <xsl:value-of select="ns0:GeneralPostingGroup/ns0:SalesAccount"/>
      </boekhpl_reknr>
      
      <bedrag>
        <xsl:value-of select="format-number(ns0:Amount, '0,00', 'EU')" />
      </bedrag>
      
      <!-- <codedc>
        <xsl:choose>
          <xsl:when test="ns0:Amount &lt;= 0">
            <xsl:text>C</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>D</xsl:text>
          </xsl:otherwise>
        </xsl:choose>  
      </codedc> -->

      <hoeveelh>
        <xsl:value-of select="format-number(ns0:Quantity, '0,000', 'EU')" />
      </hoeveelh>
      
      <!-- <valuta_code>
        <xsl:value-of select="../../ns0:CurrencyCode"/>
      </valuta_code>
      
      <koers>1,0</koers> -->
      
      <btwregimes_btwregime>
        <xsl:choose>
          <xsl:when test="ns0:VATBusPostingGroup = 'BINNENLAND'">H</xsl:when>
          <xsl:when test="ns0:VATBusPostingGroup = 'EU'">I</xsl:when>
          <xsl:when test="ns0:VATBusPostingGroup = 'EXPORT'">B</xsl:when>
          <xsl:when test="ns0:VATBusPostingGroup = 'FREE'">H</xsl:when>
        </xsl:choose>  
      </btwregimes_btwregime>
      
      <btwcodes_btwcode>
        <xsl:choose>
          <xsl:when test="ns0:VAT='21'">4</xsl:when>
          <xsl:when test="ns0:VAT='12'">3</xsl:when>
          <xsl:when test="ns0:VAT='6'">2</xsl:when>
          <xsl:when test="ns0:VAT='0'">1</xsl:when>
        </xsl:choose>
      </btwcodes_btwcode>
    </blboekhpl>
  </xsl:template>
  
</xsl:stylesheet>
