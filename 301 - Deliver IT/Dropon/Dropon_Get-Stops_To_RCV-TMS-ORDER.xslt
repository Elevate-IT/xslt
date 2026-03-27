<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/receivetmsdocument:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="//xml/stops" />
  </xsl:template>
  <xsl:template match="//xml/stops">
    <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:text>1</xsl:text>
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="MyScript:GetCurrentDate('s')" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:choose>
            <xsl:when test="contains(//billing_name, 'Mathys')">
              <xsl:text>K00002</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="//customer_ref" />
            </xsl:otherwise>
          </xsl:choose>
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:text>Deliver-IT</xsl:text>
        </ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:Documents>
        <ns0:Document>
          <!--<xsl:value-of select="MyScript:Split(deliveries/tracking_number, '-')" />
          <ns0:No>
            <xsl:value-of select="MyScript:GetFromSplitsArray(0)" />
          </ns0:No>
          <ns0:SequenceNo>
            <xsl:value-of select="MyScript:GetFromSplitsArray(1)" />
          </ns0:SequenceNo>-->
          <ns0:No>
            <xsl:value-of select="deliveries/tracking_number" />
          </ns0:No>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="deliveries/tracking_number" />
          </ns0:ExternalDocumentNo>
          <xsl:if test="deliveries/ref != ''">
            <ns0:CustomerReference>
              <xsl:value-of select="substring(deliveries/ref, 1, 30)" />
            </ns0:CustomerReference>
          </xsl:if>
          <xsl:if test="string-length(deliveries/comment) &gt; 0">
            <!-- and string-length(deliveries/comment) &lt;= 30-->
            <xsl:choose>
              <xsl:when test="deliveries/type = 'pickup'">
                <ns0:LoadReference>
                  <xsl:value-of select="substring(deliveries/comment, 1, 30)" />
                </ns0:LoadReference>
              </xsl:when>
              <xsl:otherwise>
                <ns0:UnloadReference>
                  <xsl:value-of select="substring(deliveries/comment, 1, 30)" />
                </ns0:UnloadReference>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="deliveries/type = 'pickup'">
              <ns0:LoadingDateFrom>
                <xsl:value-of select="MyScript:parseUtcDT(deliveries/due_dates/start, 'yyyy-MM-dd')" />
              </ns0:LoadingDateFrom>
              <ns0:LoadingDateTo>
                <xsl:value-of select="MyScript:parseUtcDT(deliveries/due_dates/end, 'yyyy-MM-dd')" />
              </ns0:LoadingDateTo>
              <ns0:LoadingTimeFrom>
                <xsl:value-of select="MyScript:parseUtcDT(deliveries/due_dates/start, 'HH:mm:ss')" />
              </ns0:LoadingTimeFrom>
              <ns0:LoadingTimeTo>
                <xsl:value-of select="MyScript:parseUtcDT(deliveries/due_dates/end, 'HH:mm:ss')" />
              </ns0:LoadingTimeTo>
              <ns0:FromAddressDescription>
                <xsl:value-of select="to_customer/name" />
              </ns0:FromAddressDescription>
              <ns0:FromAddressStreet>
                <xsl:value-of select="concat(location/street, ' ', location/nr)" />
              </ns0:FromAddressStreet>
              <ns0:FromAddressPostCode>
                <xsl:value-of select="location/zip" />
              </ns0:FromAddressPostCode>
              <ns0:FromAddressCity>
                <xsl:value-of select="location/city" />
              </ns0:FromAddressCity>
              <ns0:FromAddressCountryCode>
                <xsl:value-of select="location/short_country" />
              </ns0:FromAddressCountryCode>
              <xsl:if test="location/geometry/type = 'Point'">
                <ns0:FromAddressXCoordinate>
                  <xsl:value-of select="location/geometry/coordinates[2]" />
                </ns0:FromAddressXCoordinate>
                <ns0:FromAddressYCoordinate>
                  <xsl:value-of select="location/geometry/coordinates[1]" />
                </ns0:FromAddressYCoordinate>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <ns0:UnloadingDateFrom>
                <xsl:value-of select="MyScript:parseUtcDT(deliveries/due_dates/start, 'yyyy-MM-dd')" />
              </ns0:UnloadingDateFrom>
              <ns0:UnloadingDateTo>
                <xsl:value-of select="MyScript:parseUtcDT(deliveries/due_dates/end, 'yyyy-MM-dd')" />
              </ns0:UnloadingDateTo>
              <ns0:UnloadingTimeFrom>
                <xsl:value-of select="MyScript:parseUtcDT(deliveries/due_dates/start, 'HH:mm:ss')" />
              </ns0:UnloadingTimeFrom>
              <ns0:UnloadingTimeTo>
                <xsl:value-of select="MyScript:parseUtcDT(deliveries/due_dates/end, 'HH:mm:ss')" />
              </ns0:UnloadingTimeTo>
              <ns0:ToAddressDescription>
                <xsl:value-of select="to_customer/name" />
              </ns0:ToAddressDescription>
              <ns0:ToAddressStreet>
                <xsl:value-of select="concat(location/street, ' ', location/nr)" />
              </ns0:ToAddressStreet>
              <ns0:ToAddressPostCode>
                <xsl:value-of select="location/zip" />
              </ns0:ToAddressPostCode>
              <ns0:ToAddressCity>
                <xsl:value-of select="location/city" />
              </ns0:ToAddressCity>
              <ns0:ToAddressCountryCode>
                <xsl:value-of select="location/short_country" />
              </ns0:ToAddressCountryCode>
              <xsl:if test="location/geometry/type = 'Point'">
                <ns0:ToAddressXCoordinate>
                  <xsl:value-of select="location/geometry/coordinates[2]" />
                </ns0:ToAddressXCoordinate>
                <ns0:ToAddressYCoordinate>
                  <xsl:value-of select="location/geometry/coordinates[1]" />
                </ns0:ToAddressYCoordinate>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
          <ns0:StatusCode>
            <xsl:text>20-BEVESTIGD</xsl:text>
          </ns0:StatusCode>
          <!--<xsl:if test="string-length(deliveries/comment) &gt; 30">
            <ns0:Comments>
              <ns0:Comment>
                <ns0:Type>
                  <xsl:choose>
                    <xsl:when test="deliveries/type = 'pickup'">
                      <xsl:text>1</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>2</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </ns0:Type>
                <ns0:Comment>
                  <xsl:value-of select="substring(deliveries/comment, 1, 100)" />
                </ns0:Comment>
              </ns0:Comment>
            </ns0:Comments>
          </xsl:if>-->
          <ns0:DocumentLines>
            <ns0:DocumentLine>
              <xsl:variable name="itemNo">
                <xsl:if test="contains('|GOEDEREN|MED|ROL|', concat('|', translate(items/name, $lowercase, $uppercase), '|'))">
                  <xsl:value-of select="items/name" />
                </xsl:if>
              </xsl:variable>
              <ns0:Type>
                <xsl:text>1</xsl:text>
              </ns0:Type>
              <ns0:No>
                <xsl:choose>
                  <xsl:when test="$itemNo != ''">
                    <xsl:value-of select="$itemNo" />
                  </xsl:when>
                  <xsl:when test="//customer_ref = 'K00007'">
                    <xsl:text>MED</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>GOEDEREN</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </ns0:No>
              <ns0:Quantity>
                <xsl:value-of select="items/count" />
              </ns0:Quantity>
            </ns0:DocumentLine>
          </ns0:DocumentLines>
        </ns0:Document>
      </ns0:Documents>
    </ns0:Message>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[
      TimeZoneInfo toTimeZone = TimeZoneInfo.FindSystemTimeZoneById("W. Europe Standard Time");
    
      public string GetCurrentDate(string formatOut)
			{
				return System.DateTime.Now.ToString(formatOut);
			}
      
      public string parseUtcDT(string input, string formatOut)
      {
        if(System.String.IsNullOrEmpty(input)) return input;
        
        DateTime dateT = DateTime.Parse(input);
		    dateT = dateT.ToUniversalTime();
		    dateT = TimeZoneInfo.ConvertTimeFromUtc(dateT, toTimeZone);
        return dateT.ToString(formatOut);
      }
      
      public string parseDT(string input, string formatOut)
      {
        if(System.String.IsNullOrEmpty(input)) return input;
        
        DateTime dateT = DateTime.Parse(input);
		    dateT = TimeZoneInfo.ConvertTime(dateT, toTimeZone);
        return dateT.ToString(formatOut);
      }
      
      public string GetGUID()
      {
        return "{"+Guid.NewGuid().ToString()+"}";
      }    
      
      public void Sleep()
      {
        Threading.Thread.Sleep(60000);
      }
      
      public string[] splits;
      
      public void Split(string input, string seperator)
      {
        char seperatorChar = Convert.ToChar(seperator);
        splits = input.Split(seperatorChar);
      }
      
      public string GetFromSplitsArray(int i)
      {
        if (i < splits.Length)
          return splits[i];
        else
          return "";
      }

		]]>
  </msxsl:script>
</xsl:stylesheet>