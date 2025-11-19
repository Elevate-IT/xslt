<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="envelope/picking_order" />
  </xsl:template>

  <xsl:template name="index-of">
    <xsl:param name="input"/>
    <xsl:param name="substr"/>

    <xsl:choose>
      <xsl:when test="contains($input, $substr)">
        <xsl:value-of select="string-length(substring-before($input, $substr))+1"/>
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="getBatchNo">
    <xsl:param name="stringContainingBatch"/>
    <xsl:param name="partBeforeBatch"/>
    <xsl:param name="partAfterBatch"/>
    <xsl:param name="includePartBeforeBatch"/>

    <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

    <xsl:variable name="lengthPartBefore">
      <xsl:choose>
        <xsl:when test="$includePartBeforeBatch = ''">
          <xsl:value-of select="string-length($partBeforeBatch)" />
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="position1">
      <xsl:call-template name="index-of">
        <xsl:with-param name="input">
          <xsl:value-of select="translate($stringContainingBatch, $lowercase, $uppercase)" />
        </xsl:with-param>
        <xsl:with-param name="substr">
          <xsl:value-of select="translate($partBeforeBatch, $lowercase, $uppercase)" />
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="position2">
      <xsl:choose>
        <xsl:when test="$partAfterBatch = ''">0</xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="index-of">
            <xsl:with-param name="input">
              <xsl:value-of select="substring(translate($stringContainingBatch, $lowercase, $uppercase), $position1 + $lengthPartBefore)" />
            </xsl:with-param>
            <xsl:with-param name="substr">
              <xsl:value-of select="translate($partAfterBatch, $lowercase, $uppercase)" />
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="string-length($stringContainingBatch) &gt; 20">
        <xsl:choose>
          <xsl:when test="$position1 != 0">
            <xsl:choose>
              <xsl:when test="$position2 != 0">
                <xsl:value-of select="substring($stringContainingBatch, $position1 + $lengthPartBefore, $position2 - 1)" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring($stringContainingBatch, $position1 + $lengthPartBefore)" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$stringContainingBatch" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$stringContainingBatch" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="envelope/picking_order">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="//envelope/@fileID" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="//envelope/@timestamp" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:text>GALANA</xsl:text>
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:text>Zeebrugge Food Logistics</xsl:text>
        </ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:Documents>
        <ns0:Document>
          <ns0:DocumentDate>
            <xsl:value-of select="MyScript:ParseDate(order_date,'yyyy-MM-ddThh:mm:ss.fff','yyyy-MM-dd')" />
          </ns0:DocumentDate>
          <ns0:OrderDate>
            <xsl:value-of select="MyScript:ParseDate(delivery_date,'yyyy-MM-ddThh:mm:ss.fff','yyyy-MM-dd')" />
          </ns0:OrderDate>
          <ns0:DeliveryDate>
            <xsl:value-of select="MyScript:ParseDate(delivery_date,'yyyy-MM-ddThh:mm:ss.fff','yyyy-MM-dd')" />
          </ns0:DeliveryDate>
          <ns0:ArrivedDate>
            <xsl:value-of select="MyScript:ParseDate(departure_date,'yyyy-MM-dd','yyyy-MM-dd')" />
          </ns0:ArrivedDate>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="external_document" />
          </ns0:ExternalDocumentNo>
          <ns0:ExternalReference>
            <xsl:choose>
              <xsl:when test="starts-with(reference_nr, '5000')">
                <xsl:value-of select="substring(reference_nr, 5, 77)" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring(reference_nr, 1, 77)" />
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="count(//picking_order_line/picking_order_line_lot/picking_order_line_lotnr_supplier) &gt; 0">
              <xsl:text> SR</xsl:text>
            </xsl:if>
          </ns0:ExternalReference>
          <!--<ns0:SenderAddress>
            <ns0:ExternalNo>
              <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='SU']/s0:NAD/s0:C082/C08201"/>
            </ns0:ExternalNo>
          </ns0:SenderAddress>-->
          <ns0:ShipToAddress>
            <xsl:choose>
              <xsl:when test="normalize-space(recipient/address) != ''">
                <ns0:Name>
                  <xsl:value-of select="recipient/name"/>
                </ns0:Name>
                <ns0:Address>
                  <xsl:value-of select="recipient/address"/>
                </ns0:Address>
                <ns0:City>
                  <xsl:value-of select="recipient/town"/>
                </ns0:City>
                <ns0:PostCode>
                  <xsl:value-of select="recipient/postal_code"/>
                </ns0:PostCode>
                <ns0:CountryCode>
                  <xsl:value-of select="recipient/country"/>
                </ns0:CountryCode>
              </xsl:when>
              <xsl:otherwise>
                <ns0:Name>
                  <xsl:value-of select="subrecipient/name"/>
                </ns0:Name>
                <ns0:Address>
                  <xsl:value-of select="subrecipient/address"/>
                </ns0:Address>
                <ns0:City>
                  <xsl:value-of select="subrecipient/town"/>
                </ns0:City>
                <ns0:PostCode>
                  <xsl:value-of select="subrecipient/postal_code"/>
                </ns0:PostCode>
                <ns0:CountryCode>
                  <xsl:value-of select="subrecipient/country"/>
                </ns0:CountryCode>
              </xsl:otherwise>
            </xsl:choose>
          </ns0:ShipToAddress>

          <ns0:DocumentLines>
            <xsl:for-each select ="picking_order_line">
              <ns0:DocumentLine>
                <ns0:ExternalNo>
                  <xsl:value-of select="article_nr"/>
                </ns0:ExternalNo>
                <ns0:OrderQuantity>
                  <xsl:value-of select="quantity" />
                </ns0:OrderQuantity>
                <xsl:if test="picking_order_line_lot/picking_order_line_lotnr_supplier != ''">
                  <ns0:ExternalBatchNo>
                    <xsl:call-template name="getBatchNo">
                      <xsl:with-param name="stringContainingBatch">
                        <xsl:value-of select="picking_order_line_lot/picking_order_line_lotnr_supplier" />
                      </xsl:with-param>
                      <xsl:with-param name="partBeforeBatch">
                        <xsl:text>Batch No:</xsl:text>
                      </xsl:with-param>
                      <xsl:with-param name="partAfterBatch">
                        <xsl:text>,</xsl:text>
                      </xsl:with-param>
                      <xsl:with-param name="includePartBeforeBatch">
                        <xsl:text></xsl:text>
                      </xsl:with-param>
                    </xsl:call-template>
                    <!--<xsl:value-of select="picking_order_line_lot/picking_order_line_lotnr_supplier" />-->
                  </ns0:ExternalBatchNo>
                  <xsl:if test="picking_order_line_lot/picking_order_line_best_before != ''">
                    <ns0:ExpirationDate>
                      <xsl:value-of select="picking_order_line_lot/picking_order_line_best_before"/>
                    </ns0:ExpirationDate>
                  </xsl:if>
                </xsl:if>
                <!--<ns0:CarrierQuantity>
                    <xsl:value-of select="count(key('Lines-by-MATNO-THT-BATCH',$LineKey))" />
                  </ns0:CarrierQuantity>-->
                <ns0:Attributes>
                  <ns0:Attribute>
                    <ns0:Code>LINENO</ns0:Code>
                    <ns0:Value>
                      <xsl:value-of select="host_reference_nr" />
                    </ns0:Value>
                  </ns0:Attribute>
                  <xsl:if test="picking_order_line_lot/picking_order_line_lotnr_supplier != ''">
                    <ns0:Attribute>
                      <ns0:Code>EXTBATCH</ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="picking_order_line_lot/picking_order_line_lotnr_supplier" />
                      </ns0:Value>
                    </ns0:Attribute>
                  </xsl:if>
                  <xsl:if test="picking_order_line_lot/picking_order_line_lotnr_internal != ''">
                    <ns0:Attribute>
                      <ns0:Code>EXTBATCH2</ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="picking_order_line_lot/picking_order_line_lotnr_internal" />
                      </ns0:Value>
                    </ns0:Attribute>
                  </xsl:if>
                </ns0:Attributes>
              </ns0:DocumentLine>
            </xsl:for-each>
          </ns0:DocumentLines>
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