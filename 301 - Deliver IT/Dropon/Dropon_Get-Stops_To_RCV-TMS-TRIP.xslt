<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/receivetmstrip:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="//xml/stops" />
  </xsl:template>
  <xsl:template match="//xml/stops">
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
          <xsl:text>Dropon</xsl:text>
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:text>Deliver-IT</xsl:text>
        </ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:Trips>
        <ns0:Trip>
          <xsl:if test="count(trip_data) &gt; 0">
            <ns0:DocumentType>6</ns0:DocumentType>
            <ns0:No>
              <xsl:text>DITO</xsl:text>
              <xsl:value-of select="MyScript:parseUtcDT(trip_data/scheduled, 'yyyyMMdd')" />
              <xsl:text>-</xsl:text>
              <xsl:value-of select="trip_data/code" />
            </ns0:No>
            <ns0:InternalReference>
              <xsl:value-of select="trip_data/description" />
            </ns0:InternalReference>
            <ns0:FromAddressNo>ADR0000001</ns0:FromAddressNo>
            <ns0:ToAddressNo>ADR0000001</ns0:ToAddressNo>
            <ns0:ExternalDocumentNo>
              <xsl:value-of select="MyScript:parseUtcDT(trip_data/scheduled, 'yyyyMMdd')" />
              <xsl:text>-</xsl:text>
              <xsl:value-of select="trip_data/code" />
            </ns0:ExternalDocumentNo>
            <xsl:choose>
              <xsl:when test="status = '106' or status = '107'">
                <ns0:ActualStartingDate>
                  <xsl:value-of select="MyScript:parseUtcDT(updated_at, 'yyyy-MM-dd')" />
                </ns0:ActualStartingDate>
                <ns0:ActualStartingTime>
                  <xsl:value-of select="MyScript:parseUtcDT(updated_at, 'HH:mm:ss')" />
                </ns0:ActualStartingTime>
              </xsl:when>
              <xsl:when test="status = '108' or status = '109'">
                <ns0:ActualEndingDate>
                  <xsl:value-of select="MyScript:parseUtcDT(finished_at, 'yyyy-MM-dd')" />
                </ns0:ActualEndingDate>
                <ns0:ActualEndingTime>
                  <xsl:value-of select="MyScript:parseUtcDT(finished_at, 'HH:mm:ss')" />
                </ns0:ActualEndingTime>
                <ns0:ActualNumberofKilometers>
                  <xsl:value-of select="trip_data/distance div 1000" />
                </ns0:ActualNumberofKilometers>
              </xsl:when>
              <xsl:otherwise>
                <ns0:PlannedStartingDate>
                  <xsl:value-of select="MyScript:parseUtcDT(trip_data/scheduled, 'yyyy-MM-dd')" />
                </ns0:PlannedStartingDate>
                <ns0:PlannedStartingTime>
                  <xsl:value-of select="MyScript:parseUtcDT(trip_data/scheduled, 'HH:mm:ss')" />
                </ns0:PlannedStartingTime>
                <ns0:PlannedEndingDate>
                  <xsl:value-of select="MyScript:parseUtcDT(trip_data/scheduled_end, 'yyyy-MM-dd')" />
                </ns0:PlannedEndingDate>
                <ns0:PlannedEndingTime>
                  <xsl:value-of select="MyScript:parseUtcDT(trip_data/scheduled_end, 'HH:mm:ss')" />
                </ns0:PlannedEndingTime>
                <ns0:PlannedNoofKilometer>
                  <xsl:value-of select="trip_data/distance div 1000" />
                </ns0:PlannedNoofKilometer>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="trip_data/driver/id != ''">
              <xsl:if test="trip_data/asset/id != ''">
                <ns0:Resource1No>
                  <xsl:value-of select="trip_data/asset/name" />
                </ns0:Resource1No>
              </xsl:if>
              <ns0:Resource3No>
                <xsl:value-of select="trip_data/driver/name" />
              </ns0:Resource3No>
            </xsl:if>
          </xsl:if>
          <ns0:Trajects>
            <ns0:Traject>
              <xsl:value-of select="MyScript:Split(deliveries/tracking_number, '-')" />
              <ns0:No>
                <xsl:value-of select="MyScript:GetFromSplitsArray(0)" />
              </ns0:No>
              <ns0:SequenceNo>
                <xsl:value-of select="MyScript:GetFromSplitsArray(1)" />
              </ns0:SequenceNo>
              <xsl:choose>
                <xsl:when test="deliveries/type = 'pickup'">
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
              <xsl:choose>
                <xsl:when test="status = '108' or status = '109'">
                  <ns0:ActualStartingDate>
                    <xsl:value-of select="MyScript:parseUtcDT(eta, 'yyyy-MM-dd')" />
                  </ns0:ActualStartingDate>
                  <ns0:ActualStartingTime>
                    <xsl:value-of select="MyScript:parseUtcDT(eta, 'HH:mm:ss')" />
                  </ns0:ActualStartingTime>
                  <ns0:ActualEndingDate>
                    <xsl:value-of select="MyScript:parseUtcDT(finished_at, 'yyyy-MM-dd')" />
                  </ns0:ActualEndingDate>
                  <ns0:ActualEndingTime>
                    <xsl:value-of select="MyScript:parseUtcDT(finished_at, 'HH:mm:ss')" />
                  </ns0:ActualEndingTime>
                  <ns0:ActualNumberofKilometers>
                    <xsl:value-of select="distance div 1000" />
                  </ns0:ActualNumberofKilometers>
                </xsl:when>
                <xsl:otherwise>
                  <ns0:PlannedStartingDate>
                    <xsl:value-of select="MyScript:parseUtcDT(scheduled, 'yyyy-MM-dd')" />
                  </ns0:PlannedStartingDate>
                  <ns0:PlannedStartingTime>
                    <xsl:value-of select="MyScript:parseUtcDT(scheduled, 'HH:mm:ss')" />
                  </ns0:PlannedStartingTime>
                  <ns0:PlannedEndingDate>
                    <xsl:value-of select="MyScript:parseUtcDT(scheduled_departure, 'yyyy-MM-dd')" />
                  </ns0:PlannedEndingDate>
                  <ns0:PlannedEndingTime>
                    <xsl:value-of select="MyScript:parseUtcDT(scheduled_departure, 'HH:mm:ss')" />
                  </ns0:PlannedEndingTime>
                  <ns0:PlannedNumberOfKilometer>
                    <xsl:value-of select="distance div 1000" />
                  </ns0:PlannedNumberOfKilometer>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="index &gt; 0">
                <ns0:LoadSequence>
                  <xsl:value-of select="index * 100" />
                </ns0:LoadSequence>
                <ns0:UnloadSequence>
                  <xsl:value-of select="index * 100" />
                </ns0:UnloadSequence>
              </xsl:if>
              <ns0:StatusCode>
                <xsl:choose>
                  <xsl:when test="status = '101'">
                    <xsl:if test="count(deliveries/history[status &gt; 101]) &gt; 0">
                      <xsl:text>15-WIJZIGEN</xsl:text>
                    </xsl:if>
                  </xsl:when>
                  <xsl:when test="status = '105'">
                    <xsl:choose>
                      <xsl:when test="trip_data/driver/id = ''">
                        <xsl:text>20-BEVESTIGD</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>30-GEPLAND</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="status = '106'">
                    <xsl:text>40-IN UITVOERING</xsl:text>
                  </xsl:when>
                  <xsl:when test="status = '107'">
                    <xsl:text>40-IN UITVOERING</xsl:text>
                  </xsl:when>
                  <xsl:when test="status = '108'">
                    <xsl:text>50-UITGEVOERD</xsl:text>
                  </xsl:when>
                  <xsl:when test="status = '109'">
                    <xsl:text>50-UITGEVOERD</xsl:text>
                  </xsl:when>
                  <xsl:when test="status = '308'">
                    <xsl:text>90-GEANNULEERD</xsl:text>
                  </xsl:when>
                </xsl:choose>
              </ns0:StatusCode>
              <xsl:if test="sign != ''">
                <ns0:Signatures>
                  <ns0:Signature>
                    <xsl:variable name="dummy" select="MyScript:Split(translate(sign, ',', ';'), ';')" />
                    <ns0:Description>
                      <xsl:value-of select="deliveries/tracking_number" />
                      <xsl:text>_Signature_</xsl:text>
                      <xsl:value-of select="signed_by" />
                      <xsl:text>.</xsl:text>
                      <xsl:value-of select="substring(MyScript:GetFromSplitsArray(0), string-length(MyScript:GetFromSplitsArray(0)) - 2, 3)" />
                    </ns0:Description>
                    <ns0:EncodedFile>
                      <xsl:value-of select="MyScript:GetFromSplitsArray(2)" />
                    </ns0:EncodedFile>
                  </ns0:Signature>
                </ns0:Signatures>
              </xsl:if>
            </ns0:Traject>
          </ns0:Trajects>
        </ns0:Trip>
      </ns0:Trips>
    </ns0:Message>
    <!--<xsl:value-of select="MyScript:Sleep()" />-->
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