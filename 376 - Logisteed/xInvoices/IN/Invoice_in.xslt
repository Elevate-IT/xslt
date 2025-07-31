<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ns0="www.boltrics.nl/receivesapinvoice:v1.00"
                version="3.0">
  <xsl:output method="xml" indent="yes"/>
  
  <!-- Match the root -->
  <xsl:template match="/MessageLines">
    <!-- Extract the header from the first line -->
    <Message>
      <Header>
        <InvoiceNumber>
          <xsl:value-of select="normalize-space(substring(Lines[1]/Line, 1, 35))"/>
        </InvoiceNumber>
        <InvoiceDate>
          <xsl:value-of select="normalize-space(substring(Lines[1]/Line, 36, 8))"/>
        </InvoiceDate>
        <InvoiceAmount>
          <xsl:value-of select="normalize-space(substring(Lines[1]/Line, 44, 18))"/>
        </InvoiceAmount>
        <InvoiceCurrency>
          <xsl:value-of select="normalize-space(substring(Lines[1]/Line, 62, 3))"/>
        </InvoiceCurrency>
        <PaymentTerms>
          <xsl:value-of select="normalize-space(substring(Lines[1]/Line, 65, 17))"/>
        </PaymentTerms>
        <ExchangeRate>
          <xsl:value-of select="normalize-space(substring(Lines[1]/Line, 82, 12))"/>
        </ExchangeRate>
        <OraclePoNo>
          <xsl:value-of select="normalize-space(substring(Lines[1]/Line, 94, 35))"/>
        </OraclePoNo>
        <Deliveryno>
          <xsl:value-of select="normalize-space(substring(Lines[1]/Line, 129, 35))"/>
        </Deliveryno>
      </Header>
      <Lines>
        <!-- Loop through each Lines/Line -->
        <xsl:for-each select="Lines/Line">
          <Line>
            <ERPLineNo>
              <xsl:value-of select="normalize-space(substring(., 164, 6))"/>
            </ERPLineNo>
            <VATRate>
              <xsl:value-of select="normalize-space(substring(., 170, 17))"/>
            </VATRate>
            <VATCode>
              <xsl:value-of select="normalize-space(substring(., 187, 7))"/>
            </VATCode>
            <InvoiceTaxAmount>
              <xsl:value-of select="normalize-space(substring(., 194, 18))"/>
            </InvoiceTaxAmount>
            <OraclePOLineNo>
              <xsl:value-of select="normalize-space(substring(., 212, 6))"/>
            </OraclePOLineNo>
            <Quantity>
              <xsl:value-of select="normalize-space(substring(., 218, 15))"/>
            </Quantity>
            <UnitPrice>
              <xsl:value-of select="normalize-space(substring(., 233, 15))"/>
            </UnitPrice>
            <ItemNo>
              <xsl:value-of select="normalize-space(substring(., 248, 35))"/>
            </ItemNo>
            <InvLineNetVal>
              <xsl:value-of select="normalize-space(substring(., 283, 18))"/>
            </InvLineNetVal>
            <CountryOfOrigin>
              <xsl:value-of select="normalize-space(substring(., 301, 3))"/>
            </CountryOfOrigin>
            <NetWeight>
              <xsl:value-of select="normalize-space(substring(., 304, 18))"/>
            </NetWeight>
            <GrossWeight>
              <xsl:value-of select="normalize-space(substring(., 322, 18))"/>
            </GrossWeight>
            <HSCode>
              <xsl:value-of select="normalize-space(substring(., 332, 10))"/>
            </HSCode>
          </Line>
        </xsl:for-each>
      </Lines>
    </Message>
  </xsl:template>
  
</xsl:stylesheet>

<!-- 
     Delivery Number    
     <xsl:value-of select="normalize-space(substring(Line, 129, 6))"/>
     
     VAT Rate   
     <xsl:value-of select="normalize-space(substring(Line, 135, 17))"/>
     
     VAT Code    
     <xsl:value-of select="normalize-space(substring(Line, 152, 7))"/>
     
     Invoice Tax Amount   
     <xsl:value-of select="normalize-space(substring(Line, 159, 18))"/>
     
     Quantity  
     <xsl:value-of select="normalize-space(substring(Line, 177, 15))"/>
     
     Unit Price   
     <xsl:value-of select="normalize-space(substring(Line, 192, 15))"/>
     
     Item Number   
     <xsl:value-of select="normalize-space(substring(Line, 207, 35))"/>
     
     Invoice Line Net Value    
     <xsl:value-of select="normalize-space(substring(Line, 242, 8))"/>
     
     Country Of Origin     
     <xsl:value-of select="normalize-space(substring(Line, 250, 3))"/>
     
     Net Weight   
     <xsl:value-of select="normalize-space(substring(Line, 253, 18))"/>
     
     Total Weight    
     <xsl:value-of select="normalize-space(substring(Line, 271, 18))"/>
     
     Commodity No    
     <xsl:value-of select="normalize-space(substring(Line, 289, 10))"/>
     
-->



