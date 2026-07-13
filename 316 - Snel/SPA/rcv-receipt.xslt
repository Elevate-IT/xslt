<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/receivereceipt:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="NAVIPWMS/HEADER" />
  </xsl:template>
  
  <xsl:key name="Group-by-CUSTPRODCODE-LINENO-PROD-THT-BATCH" match="//DETAIL/ITEMLINE" use="concat(CUSTPRODCODE, '-', LINENO, '-', ASKED/TRACKING/PRODUCTIONDATE,'-',ASKED/TRACKING/REQEXPDATE,'-',ASKED/TRACKING/REQLOT)" />
  
  <xsl:template match="NAVIPWMS/HEADER">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="MyScript:GetGUID()" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="MyScript:GetCurrentDate('yyyy-MM-ddThh:mm:ss')" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:text>SPA</xsl:text>
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:text>Snel</xsl:text>
        </ns0:ToTradingPartner>
        <!--<ns0:OrderTypeCode>ASN</ns0:OrderTypeCode>-->
      </ns0:Header>
      <ns0:Documents>
        <ns0:Document>
          <ns0:DocumentDate>
            <xsl:value-of select="MyScript:ParseDate(DATE,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:DocumentDate>
          <!--<ns0:OrderDate>
               <xsl:value-of select="order_date" />
               </ns0:OrderDate>-->
          <ns0:DeliveryDate>
            <xsl:value-of select="MyScript:ParseDate(DATE,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:DeliveryDate>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="CUSTREFDOC" />
          </ns0:ExternalDocumentNo>
          <ns0:ExternalReference>
            <xsl:value-of select="EXTREF" />
          </ns0:ExternalReference>
          <xsl:if test="ADDRESSES/ADDRESS[ADDRTYPE = 'CARRIER']/ADDRCODE != ''">
            <ns0:ShippingAgent>
              <ns0:Name>
                <!--Concat two values split by ' - ':
                     1. ADDRCODE padded with 0 to length 10 if shorter
                     2. ADDRNAME-->
                <xsl:choose>
                  <xsl:when test="ADDRESSES/ADDRESS[ADDRTYPE = 'CARRIER']/ADDRNAME != ''">
                    <xsl:value-of select="concat(concat(substring('0000000000', 1, 10 - string-length(ADDRESSES/ADDRESS[ADDRTYPE = 'CARRIER']/ADDRCODE)), ADDRESSES/ADDRESS[ADDRTYPE = 'CARRIER']/ADDRCODE), ' - ', normalize-space(ADDRESSES/ADDRESS[ADDRTYPE = 'CARRIER']/ADDRNAME))" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="concat(substring('0000000000', 1, 10 - string-length(ADDRESSES/ADDRESS[ADDRTYPE = 'CARRIER']/ADDRCODE)), ADDRESSES/ADDRESS[ADDRTYPE = 'CARRIER']/ADDRCODE)" />
                  </xsl:otherwise>
                </xsl:choose>
              </ns0:Name>
            </ns0:ShippingAgent>
          </xsl:if>
          <ns0:TrailerContainerNo>
            <xsl:value-of select="TRAILER"/>
          </ns0:TrailerContainerNo>
          <ns0:SenderAddress>
            <ns0:No>
              <xsl:value-of select="number(ADDRESSES/ADDRESS[ADDRTYPE='LOADING']/ADDRCODE)"/>
            </ns0:No>
            <ns0:ExternalNo>
              <xsl:value-of select="number(ADDRESSES/ADDRESS[ADDRTYPE='LOADING']/ADDRCODE)"/>
            </ns0:ExternalNo>
            <ns0:EANCode>
              <xsl:value-of select="number(ADDRESSES/ADDRESS[ADDRTYPE='LOADING']/ADDRCODE)"/>
            </ns0:EANCode>
            <ns0:Name>
              <xsl:value-of select="ADDRESSES/ADDRESS[ADDRTYPE='LOADING']/ADDRNAME"/>
            </ns0:Name>
            <ns0:Address>
              <xsl:value-of select="ADDRESSES/ADDRESS[ADDRTYPE='LOADING']/ADDRESS"/>
            </ns0:Address>
            <ns0:Address2>
              <xsl:value-of select="ADDRESSES/ADDRESS[ADDRTYPE='LOADING']/ADDRESS2"/>
            </ns0:Address2>
            <ns0:City>
              <xsl:value-of select="ADDRESSES/ADDRESS[ADDRTYPE='LOADING']/CITY"/>
            </ns0:City>
            <ns0:PostCode>
              <xsl:value-of select="ADDRESSES/ADDRESS[ADDRTYPE='LOADING']/POSTC"/>
            </ns0:PostCode>
            <ns0:County>
              <xsl:value-of select="ADDRESSES/ADDRESS[ADDRTYPE='LOADING']/COUNTY"/>
            </ns0:County>
            <ns0:CountryRegionCode>
              <xsl:value-of select="ADDRESSES/ADDRESS[ADDRTYPE='LOADING']/CNTRY"/>
            </ns0:CountryRegionCode>
          </ns0:SenderAddress>
          <ns0:ShipToAddress>
            <ns0:No>
              <xsl:value-of select="number(ADDRESSES/ADDRESS[ADDRTYPE='UNLOADING']/ADDRCODE)"/>
            </ns0:No>
            <ns0:ExternalNo>
              <xsl:value-of select="number(ADDRESSES/ADDRESS[ADDRTYPE='UNLOADING']/ADDRCODE)"/>
            </ns0:ExternalNo>
            <ns0:EANCode>
              <xsl:value-of select="number(ADDRESSES/ADDRESS[ADDRTYPE='UNLOADING']/ADDRCODE)"/>
            </ns0:EANCode>
            <ns0:Name>
              <xsl:value-of select="ADDRESSES/ADDRESS[ADDRTYPE='UNLOADING']/ADDRNAME"/>
            </ns0:Name>
            <ns0:Address>
              <xsl:value-of select="ADDRESSES/ADDRESS[ADDRTYPE='UNLOADING']/ADDRESS"/>
            </ns0:Address>
            <ns0:Address2>
              <xsl:value-of select="ADDRESSES/ADDRESS[ADDRTYPE='UNLOADING']/ADDRESS2"/>
            </ns0:Address2>
            <ns0:City>
              <xsl:value-of select="ADDRESSES/ADDRESS[ADDRTYPE='UNLOADING']/CITY"/>
            </ns0:City>
            <ns0:PostCode>
              <xsl:value-of select="ADDRESSES/ADDRESS[ADDRTYPE='UNLOADING']/POSTC"/>
            </ns0:PostCode>
            <ns0:County>
              <xsl:value-of select="ADDRESSES/ADDRESS[ADDRTYPE='UNLOADING']/COUNTY"/>
            </ns0:County>
            <ns0:CountryRegionCode>
              <xsl:value-of select="ADDRESSES/ADDRESS[ADDRTYPE='UNLOADING']/CNTRY"/>
            </ns0:CountryRegionCode>
          </ns0:ShipToAddress>
          
          <xsl:if test="count(DETAIL/ITEMLINE)&gt;0">
            <ns0:DocumentLines>
              <xsl:for-each select="DETAIL/ITEMLINE[count(. | key('Group-by-CUSTPRODCODE-LINENO-PROD-THT-BATCH',concat(CUSTPRODCODE, '-', LINENO, '-', ASKED/TRACKING/PRODUCTIONDATE,'-',ASKED/TRACKING/REQEXPDATE,'-',ASKED/TRACKING/REQLOT))[1]) = 1]">
                <xsl:variable name="LineKey" select="concat(CUSTPRODCODE, '-', LINENO, '-', ASKED/TRACKING/PRODUCTIONDATE,'-',ASKED/TRACKING/REQEXPDATE,'-',ASKED/TRACKING/REQLOT)" />
                <xsl:if test="$LineKey != '--'">
                  <ns0:DocumentLine>
                    <ns0:No>
                      <xsl:value-of select="CUSTPRODCODE"/>
                    </ns0:No>
                    <ns0:GTIN>
                      <xsl:value-of select="EANCODE"/>
                    </ns0:GTIN>
                    <ns0:ExternalBatchNo>
                      <xsl:value-of select="ASKED/TRACKING/REQLOT"/>
                    </ns0:ExternalBatchNo>
                    <xsl:choose>
                      <xsl:when test="count(ASKED/TRACKING/REQSSCC) &gt; 0">
                        <ns0:CarrierQuantity>
                          <xsl:value-of select="sum(key('Group-by-CUSTPRODCODE-LINENO-PROD-THT-BATCH',$LineKey)/ASKED/QUANT)"/>
                        </ns0:CarrierQuantity>
                      </xsl:when>
                      <xsl:otherwise>
                        <ns0:Quantity>
                          <xsl:value-of select="sum(key('Group-by-CUSTPRODCODE-LINENO-PROD-THT-BATCH',$LineKey)/ASKED/QUANT)"/>
                        </ns0:Quantity>
                        <xsl:if test="substring(CUSTPRODCODE, string-length(CUSTPRODCODE) - 2) != '000'">
                          <ns0:CarrierQuantity>
                            <xsl:value-of select="ceiling(sum(key('Group-by-CUSTPRODCODE-LINENO-PROD-THT-BATCH',$LineKey)/ASKED/QUANT) div format-number(substring(CUSTPRODCODE, string-length(CUSTPRODCODE) - 2), '#'))"/>
                          </ns0:CarrierQuantity>
                        </xsl:if>
                      </xsl:otherwise>
                    </xsl:choose>
                    <ns0:ExpirationDate>
                      <xsl:value-of select="MyScript:ParseDate(ASKED/TRACKING/REQEXPDATE,'yyyyMMdd','yyyy-MM-dd')"/>
                    </ns0:ExpirationDate>
                    <ns0:ProductionDate>
                      <xsl:value-of select="MyScript:ParseDate(ASKED/TRACKING/PRODUCTIONDATE,'yyyyMMdd','yyyy-MM-dd')"/>
                    </ns0:ProductionDate>
                    <ns0:InitialCarrierStatusCode>Q-QUARANTAINE</ns0:InitialCarrierStatusCode>
                    <ns0:Attributes>
                      <ns0:Attribute>
                        <ns0:Code>LINENO</ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="LINENO" />
                        </ns0:Value>
                      </ns0:Attribute>
                    </ns0:Attributes>
                    <xsl:if test="count(ASKED/TRACKING/REQSSCC) &gt; 0">
                      <ns0:DocumentDetailLines>
                        <xsl:for-each select="key('Group-by-CUSTPRODCODE-LINENO-PROD-THT-BATCH',$LineKey)">
                          <ns0:DocumentDetailLine>
                            <ns0:CarrierNo>
                              <xsl:value-of select="ASKED/TRACKING/REQSSCC"/>
                            </ns0:CarrierNo>
                            <ns0:Quantity>
                              <xsl:value-of select="format-number(substring(CUSTPRODCODE, string-length(CUSTPRODCODE) - 2), '#')"/>
                            </ns0:Quantity>
                            <ns0:InitialCarrierStatusCode>Q-QUARANTAINE</ns0:InitialCarrierStatusCode>
                            <!--<ns0:ExpirationDate>
                                 <xsl:value-of select="MyScript:ParseDate(REQEXPDATE,'yyyyMMdd','yyyy-MM-dd')"/>
                                 </ns0:ExpirationDate>-->
                            <ns0:ExternalCarrierNo>
                              <xsl:value-of select="ASKED/TRACKING/REQEXTPALLETNO"/>
                            </ns0:ExternalCarrierNo>
                          </ns0:DocumentDetailLine>
                        </xsl:for-each>
                      </ns0:DocumentDetailLines>
                    </xsl:if>
                  </ns0:DocumentLine>
                </xsl:if>
              </xsl:for-each>
            </ns0:DocumentLines>
          </xsl:if>
        </ns0:Document>
      </ns0:Documents>
    </ns0:Message>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			

      public int LINCounter = 0;
      public string GetLinCounter()
      {
          LINCounter = LINCounter + 1;
          return LINCounter.ToString();
      }   
      
		public string GetCurrentDate(string formatOut)
		{
			return System.DateTime.Now.ToString(formatOut);
		}
      
      public string ParseEOMDate(string input, string formatIn, string formatOut)
      {
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        DateTime endOfMonth = new DateTime(dateT.Year, dateT.Month, DateTime.DaysInMonth(dateT.Year, dateT.Month));
        return endOfMonth.ToString(formatOut);
      }
      
      public string ParseDate(string input, string formatIn, string formatOut)
      {
        if(System.String.IsNullOrEmpty(input)) return input;
        
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        return dateT.ToString(formatOut);
      }
      
      public string GetGUID()
      {
        return "{"+Guid.NewGuid().ToString()+"}";
      }            

		]]>
  </msxsl:script>
</xsl:stylesheet>
