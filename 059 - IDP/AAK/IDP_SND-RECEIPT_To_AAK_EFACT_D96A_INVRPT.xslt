<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/sendreceipt:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
  </xsl:template>
  <xsl:template match="//s0:Message/s0:Documents/s0:Document">
    <ns0:EFACT_D96A_INVRPT>
      <UNH>
        <UNH1>
          <xsl:value-of select="//s0:Header/s0:MessageID" />
        </UNH1>
        <UNH2>
          <UNH2.1>INVRPT</UNH2.1>
          <UNH2.2>D</UNH2.2>
          <UNH2.3>96A</UNH2.3>
          <UNH2.4>UN</UNH2.4>
        </UNH2>
      </UNH>
      <ns0:BGM>
        <ns0:C002>
          <C00201>78</C00201>
          <C00203>9</C00203>
          <C00204>INBOUND</C00204>
        </ns0:C002>
        <BGM02>ONBEKEND</BGM02>
        <BGM03>9</BGM03>
      </ns0:BGM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>366</C50701>
          <C50702>
            <xsl:value-of select="MyScript:ParseDate(//s0:Header/s0:CreationDateTime, 's', 'yyyyMMdd')" />
          </C50702>
          <C50703>102</C50703>
        </ns0:C507>
      </ns0:DTM>
      <ns0:RFFLoop1>
        <ns0:RFF>
          <ns0:C506>
            <C50601>SRN</C50601>
            <C50602>
              <xsl:value-of select="s0:ExternalDocumentNo" />
            </C50602>
          </ns0:C506>
        </ns0:RFF>
      </ns0:RFFLoop1>
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>WH</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="//s0:FromTradingPartner" />
            </C08201>
            <C08203>9</C08203>
          </ns0:C082>
          <ns0:C080>
            <C08001>IDP</C08001>
          </ns0:C080>
        </ns0:NAD>
      </ns0:NADLoop1>
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>SU</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="//s0:ToTradingPartner" />
            </C08201>
            <C08203>9</C08203>
          </ns0:C082>
          <ns0:C080>
            <C08001>AAK</C08001>
          </ns0:C080>
        </ns0:NAD>
      </ns0:NADLoop1>

      <xsl:for-each select="s0:Carriers/s0:Carrier/s0:Contents/s0:Content">
        <ns0:LINLoop1>
          <ns0:LIN>
            <LIN01>
              <xsl:value-of select="MyScript:GetLinCounter()"/>
            </LIN01>
            <ns0:C212>
              <C21201>
                <xsl:value-of select="s0:EANCode" />
              </C21201>
              <C21202>EN</C21202>
            </ns0:C212>
          </ns0:LIN>
          <ns0:PIA>
            <PIA01>5</PIA01>
            <ns0:C212_2>
              <C21201>
                <xsl:value-of select="s0:ExternalNo" />
              </C21201>
              <C21202>SA</C21202>
            </ns0:C212_2>
          </ns0:PIA>
          <ns0:QTYLoop2>
            <ns0:QTY_2>
              <ns0:C186_2>
                <C18601>145</C18601>
                <C18602>
                  <xsl:value-of select="s0:Quantity" />
                </C18602>
              </ns0:C186_2>
            </ns0:QTY_2>
            <ns0:INV>
              <INV01>2</INV01>
              <INV03>
                <xsl:choose>
                  <xsl:when test="s0:Attribute10 = '10-NIEUW'">00</xsl:when>
                  <xsl:when test="s0:Attribute10 = 'BLOCKEDPMT'">00</xsl:when>
                  <xsl:when test="s0:Attribute10 = 'FREE-TO-SHIP'">00</xsl:when>
                  <xsl:when test="s0:Attribute10 = 'MATURATION'">00</xsl:when>
                  <xsl:when test="s0:Attribute10 = 'PAST-SHELFLIFE'">00</xsl:when>
                  <xsl:when test="s0:Attribute10 = 'REJECTED'">00</xsl:when>
                </xsl:choose>
              </INV03>
            </ns0:INV>
            <ns0:GIN_2>
              <GIN01>BX</GIN01>
              <ns0:C208_6>
                <C20801>
                  <xsl:value-of select="s0:ExternalBatchNo" />
                </C20801>
              </ns0:C208_6>
            </ns0:GIN_2>
            <ns0:DTM_8>
              <ns0:C507_8>
                <C50701>361</C50701>
                <C50702>
                  <xsl:value-of select="MyScript:ParseDate(s0:ExpirationDate, 'yyyy-MM-dd', 'yyyyMMdd')" />
                </C50702>
                <C50703>102</C50703>
              </ns0:C507_8>
            </ns0:DTM_8>
            <ns0:DTM_8>
              <ns0:C507_8>
                <C50701>179</C50701>
                <C50702>
                  <xsl:value-of select="MyScript:ParseDate(s0:CreationDateTime, 's', 'yyyyMMddHHmmss')" />
                </C50702>
                <C50703>204</C50703>
              </ns0:C507_8>
            </ns0:DTM_8>
          </ns0:QTYLoop2>

          <!--<ns0:INVLoop1>
            <ns0:INV>
              <ns0:C522>
                <C52201>
                  <xsl:choose>
                    <xsl:when test="MyScript:ConvertStatusCode(s0:StatusCode) = 'FREE'">Y01</xsl:when>
                    <xsl:when test="MyScript:ConvertStatusCode(s0:StatusCode) = 'QUALITY'">Y03</xsl:when>
                    <xsl:when test="MyScript:ConvertStatusCode(s0:StatusCode) = 'BLOCKED'">Y05</xsl:when>
                  </xsl:choose>
                </C52201>
                <C52203>MB1C</C52203>
                <C52204>91</C52204>
              </ns0:C522>
            </ns0:INV>
            <ns0:QTY_2>
              <ns0:C186_2>
                <C18601>51</C18601>
                <C18602>
                  <xsl:value-of select="sum(key('Group-by-MATNO-THT-BATCH-STATUS',$LineKey)/s0:Contents/s0:Content/s0:Quantity)" />
                </C18602>
                <C18603>EDU</C18603>
              </ns0:C186_2>
            </ns0:QTY_2>
            <ns0:GIN_2>
              <GIN01>BX</GIN01>
              <ns0:C208_6>
                <C20801>
                  <xsl:value-of select="substring(s0:Contents/s0:Content/s0:ExternalBatchNo,1, 10)"/>
                </C20801>
              </ns0:C208_6>
            </ns0:GIN_2>
            <ns0:LOC_3>
              <LOC01>18</LOC01>
              <ns0:C517_3>
                <C51701>E172</C51701>
                <C51703>91</C51703>
              </ns0:C517_3>
              <ns0:C519_3>
                <C51901>0101</C51901>
                <C51903>91</C51903>
              </ns0:C519_3>
            </ns0:LOC_3>
            <ns0:DTM_8>
              <ns0:C507_8>
                <C50701>361</C50701>
                <C50702>
                  <xsl:value-of select="MyScript:ParseDate(s0:Contents/s0:Content/s0:ExpirationDate, 'yyyy-MM-dd', 'yyyyMMdd')" />
                </C50702>
                <C50703>102</C50703>
              </ns0:C507_8>
            </ns0:DTM_8>
          </ns0:INVLoop1>-->
        </ns0:LINLoop1>
      </xsl:for-each>
    </ns0:EFACT_D96A_INVRPT>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			
      int CPSCounter = 0;
      public string GetCPSCounter()
      {
        return (++CPSCounter).ToString();
      }
      
      public int NRCounter2 = 1;
      public string GetNRCounter2(bool increment)
      {
        if (increment)
          NRCounter2 += 1;
        return (NRCounter2).ToString();
      }
      
      public string GetNRCounter3()
      {
        return (NRCounter2 - 1).ToString();
      }
            
      public int NRCounter = 0;
      public string GetNRCounter(bool increment)
      {
        if (increment){
          NRCounter2 = 1;
          NRCounter += 1;
        }        
        return (NRCounter).ToString();
      }
      
      public int LINCounter = 0;
      public string GetLinCounter()
      {
          LINCounter = LINCounter + 1;
          return LINCounter.ToString();
      }
      
      public string ToUpper(string input)
			{
				return input.ToUpper();
			}
      
      public string Replace(string input, string toReplace, string replaceTo)
			{
				return input.Replace(toReplace,replaceTo);
			}
      
      public int Abs(int input)
			{
				return Math.Abs(input);
			}
      
			public string GetCurrentDate(string formatOut)
			{
				return System.DateTime.Now.ToString(formatOut);
			}
      
      public string ParseDate(string input, string formatIn, string formatOut)

      {
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        return dateT.ToString(formatOut);
      }
      
      public string GetGUID()
      {
        return "{"+Guid.NewGuid().ToString()+"}";
      }
      
     public string ConvertStatusCode(string StatusCode)
      {
        switch (StatusCode)
        {
          case "10-NIEUW":
          return "FREE";
          
          case "15-WIJZIG":
          return "FREE";
          
          case "20-VRIJ":
          return "FREE";
          
          case "30-ORDERPICK":
          return "FREE";
          
          case "40-KLAARGEZET":
          return "FREE";
          
          case "50-QUARANTAINE":
          return "QUALITY";
          
          case "90-GEBLOKKEERD":
          return "BLOCKED";
          
          default:
          return "FREE";
        }
      }
     
    public int QtyOnCarrier {get;set;}
    public void AddToQtyOnCarrier(int qtyOnCarrier)
	  {       
       QtyOnCarrier = QtyOnCarrier + qtyOnCarrier;             
    }
    
    public void SetQtyOnCarrier(int qtyOnCarrier)
	  {       
       QtyOnCarrier = qtyOnCarrier;             
    }
    
    public int GetQtyOnCarrier()
	  {       
       return QtyOnCarrier;             
    }
             
    public int QtyOnCarrierRetour {get;set;}
    public void AddToQtyOnCarrierRetour(int qtyOnCarrierRetour)
	  {       
       QtyOnCarrierRetour = QtyOnCarrierRetour + qtyOnCarrierRetour;             
    }
    
    public void SetQtyOnCarrierRetour(int qtyOnCarrierRetour)
	  {       
       QtyOnCarrierRetour = qtyOnCarrierRetour;             
    }
    
    public int GetQtyOnCarrierRetour()
	  {       
       return QtyOnCarrierRetour;             
    }
      
		]]>
  </msxsl:script>
</xsl:stylesheet>