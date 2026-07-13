<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="NAVIPWMS/HEADER" />
  </xsl:template>
  
  <xsl:template name="loopDocLine">
    <xsl:param name="i"/>
    <xsl:param name="max"/>
    <xsl:param name="ITEMLINE"/>
    
    <xsl:choose>
      <xsl:when test="substring($ITEMLINE/CUSTPRODCODE, string-length($ITEMLINE/CUSTPRODCODE) - 2) = '000'">
        <ns0:DocumentLine>
          <ns0:No>
            <xsl:value-of select="$ITEMLINE/CUSTPRODCODE"/>
          </ns0:No>
          <ns0:Description>
            <xsl:value-of select="normalize-space($ITEMLINE/DESCR)"/>
          </ns0:Description>
          <ns0:Quantity>
            <xsl:value-of select="$ITEMLINE/ASKED/QUANT"/>
          </ns0:Quantity>
          <ns0:CarrierQuantity>
            <xsl:text>1</xsl:text>
          </ns0:CarrierQuantity>
        </ns0:DocumentLine>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$i &lt;= $max">
          
          <ns0:DocumentLine>
            <ns0:No>
              <xsl:value-of select="$ITEMLINE/CUSTPRODCODE"/>
            </ns0:No>
            <ns0:Description>
              <xsl:value-of select="normalize-space($ITEMLINE/DESCR)"/>
            </ns0:Description>
            <ns0:Quantity>
              <!--Hopefully a temp solution, using last 3 char of item code to fill Quantity. Should be possible with validate CarrierQuantity-->
              <xsl:value-of select="format-number(substring($ITEMLINE/CUSTPRODCODE, string-length($ITEMLINE/CUSTPRODCODE) - 2), '#')"/>
            </ns0:Quantity>
            <ns0:CarrierQuantity>
              <xsl:text>1</xsl:text>
            </ns0:CarrierQuantity>
          </ns0:DocumentLine>
          
          <xsl:call-template name="loopDocLine">
            <xsl:with-param name="i" select="$i + 1"/>
            <xsl:with-param name="max" select="$max"/>
            <xsl:with-param name="ITEMLINE" select="$ITEMLINE" />
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
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
      </ns0:Header>
      <ns0:Documents>
        <ns0:Document>
          <ns0:DocumentDate>
            <xsl:value-of select="MyScript:ParseDate(DATE,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:DocumentDate>
          <ns0:PostingDate>
            <xsl:value-of select="MyScript:ParseDate(UNLOADDATE,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:PostingDate>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="CUSTREFDOC" />
          </ns0:ExternalDocumentNo>
          <ns0:ExternalReference>
            <xsl:value-of select="ADDRESSES/ADDRESS[ADDRTYPE = 'UNLOADING']/REF" />
          </ns0:ExternalReference>
          <!--<ns0:Attribute01>
               <xsl:value-of select="EXTRAINFO"/>
               </ns0:Attribute01>-->
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
          <ns0:VehicleNo>
            <xsl:value-of select="VEHICLE"/>
          </ns0:VehicleNo>
          <ns0:TrailerContainerNo>
            <xsl:value-of select="TRAILER"/>
          </ns0:TrailerContainerNo>
          <ns0:AnnouncedDate>
            <xsl:value-of select="MyScript:ParseDate(UNLOADDATE,'yyyyMMdd','yyyy-MM-dd')"/>
          </ns0:AnnouncedDate>
          <xsl:if test="UNLOADHOURFROM != ''">
            <ns0:AnnouncedTime>
              <xsl:value-of select="MyScript:ParseDate(UNLOADHOURFROM,'HHmm','HH:mm:ss')"/>
            </ns0:AnnouncedTime>
          </xsl:if>
          <ns0:DepartedDate>
            <xsl:value-of select="MyScript:ParseDate(UNLOADDATE,'yyyyMMdd','yyyy-MM-dd')"/>
          </ns0:DepartedDate>
          <ns0:PlannedStartDate>
            <xsl:value-of select="MyScript:ParseDate(UNLOADDATE,'yyyyMMdd','yyyy-MM-dd')"/>
          </ns0:PlannedStartDate>
          <xsl:if test="UNLOADHOURFROM != ''">
            <ns0:PlannedStartTime>
              <xsl:value-of select="MyScript:ParseDate(UNLOADHOURFROM,'HHmm','HH:mm:ss')"/>
            </ns0:PlannedStartTime>
          </xsl:if>
          <xsl:if test="UNLOADHOURTILL != ''">
            <ns0:PlannedEndTime>
              <xsl:value-of select="MyScript:ParseDate(UNLOADHOURTILL,'HHmm','HH:mm:ss')"/>
            </ns0:PlannedEndTime>
          </xsl:if>
          <ns0:DeliveryDate>
            <xsl:value-of select="MyScript:ParseDate(UNLOADDATE,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:DeliveryDate>
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
          <!--<ns0:ShipperAddress>
               <ns0:Name>
               <xsl:value-of select="ADDRESSES/ADDRESS[ADDRTYPE='CARRIER']/ADDRNAME"/>
               </ns0:Name>
               <ns0:ExternalNo>
               <xsl:value-of select="ADDRESSES/ADDRESS[ADDRTYPE='CARRIER']/ADDRCODE"/>
               </ns0:ExternalNo>
               </ns0:ShipperAddress>-->
          
          <xsl:if test="count(COMMENTS/COMMENTLINE) &gt; 0">
            <ns0:DocumentComments>
              <xsl:for-each select="COMMENTS/COMMENTLINE">
                <ns0:DocumentComment>
                  <ns0:Code>
                    <xsl:text>LOSINSTRUCTIE</xsl:text>
                  </ns0:Code>
                  <ns0:Comment>
                    <xsl:value-of select="." />
                  </ns0:Comment>
                </ns0:DocumentComment>
              </xsl:for-each>
            </ns0:DocumentComments>
          </xsl:if>
          
          <xsl:if test="count(DETAIL/ITEMLINE)&gt;0">
            <ns0:DocumentLines>
              <xsl:for-each select="DETAIL/ITEMLINE">
                <xsl:call-template name="loopDocLine">
                  <xsl:with-param name="i">1</xsl:with-param>
                  <xsl:with-param name="max" select="ASKED/QUANT"/>
                  <xsl:with-param name="ITEMLINE" select="." />
                </xsl:call-template>
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
