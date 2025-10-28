<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/stockstatus:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:key name="Group-by-MATNO-THT-BATCH-STATUS" match="//s0:Message/s0:Customers/s0:Customer/s0:Carriers/s0:Carrier/s0:ContentLines/s0:CarrierContent" use="concat(s0:CustomerItemNo,'-',s0:ExpirationDate,'-',s0:ExBatchNo,'-',../../s0:StatusCode)" />
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Customers/s0:Customer" />
  </xsl:template>

  <xsl:template name="AlphaNumeric">
    <xsl:param name="Input" />
    <xsl:value-of select="
      translate(
        $Input,
        translate(
          $Input, 
          'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
          ''
        ),
        ''
      )"
    />
  </xsl:template>

  <xsl:template match="//s0:Message/s0:Customers/s0:Customer">
    <ns0:EFACT_D16B_INVRPT>
      <UNH>
        <UNH1>
          <xsl:value-of select="//s0:Header/s0:MessageID" />
        </UNH1>
        <UNH2>
          <UNH2.1>INVRPT</UNH2.1>
          <UNH2.2>D</UNH2.2>
          <UNH2.3>16B</UNH2.3>
          <UNH2.4>UN</UNH2.4>
          <UNH2.5>EAN006</UNH2.5>
        </UNH2>
      </UNH>
      <ns0:BGM>
        <ns0:C002>
          <C00201>35</C00201>
          <C00202>
            <xsl:value-of select="//s0:Header/s0:MessageID" />
          </C00202>
          <C00203>9</C00203>
        </ns0:C002>
      </ns0:BGM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>137</C50701>
          <C50702>
            <xsl:value-of select="MyScript:ParseDate(//s0:Header/s0:CreationDateTime, 's', 'yyyyMMddHHmm')" />
          </C50702>
          <C50703>203</C50703>
        </ns0:C507>
      </ns0:DTM>
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>LSP</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="5430002021003" />
            </C08201>
            <C08202>BE ZFL</C08202>
            <C08203>9</C08203>
          </ns0:C082>
        </ns0:NAD>
      </ns0:NADLoop1>
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>SU</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="5413476000002" />
            </C08201>
            <C08203>9</C08203>
          </ns0:C082>
        </ns0:NAD>
      </ns0:NADLoop1>

      <xsl:for-each select="//s0:CarrierContent[count(. | key('Group-by-MATNO-THT-BATCH-STATUS', concat(s0:CustomerItemNo,'-',s0:ExpirationDate,'-',s0:ExBatchNo,'-',../../s0:StatusCode))[1]) = 1]">
        <xsl:variable name="LineKey" select="concat(s0:CustomerItemNo,'-',s0:ExpirationDate,'-',s0:ExBatchNo,'-',../../s0:StatusCode)" />
        <xsl:if test="concat(s0:CustomerItemNo,'-',s0:ExpirationDate,'-',s0:ExBatchNo,'-',../../s0:StatusCode) != '---'">
          <xsl:if test="sum(key('Group-by-MATNO-THT-BATCH-STATUS',$LineKey)/s0:Quantity) &gt; 0">

            <ns0:LINLoop1>
              <ns0:LIN>
                <LIN01>
                  <xsl:value-of select="MyScript:GetLinCounter()"/>
                </LIN01>
                <ns0:C212>
                  <C21201>
                    <xsl:value-of select="s0:EANCode" />
                  </C21201>
                  <C21202>SRV</C21202>
                </ns0:C212>
              </ns0:LIN>
              <ns0:PIA>
                <PIA01>5</PIA01>
                <ns0:C212_2>
                  <C21201>
                    <xsl:value-of select="s0:ExternalCustomerItemNo" />
                  </C21201>
                  <C21202>SA</C21202>
                </ns0:C212_2>
              </ns0:PIA>
              <ns0:INVLoop1>
                <ns0:INV>
                  <INV04>1</INV04>
                </ns0:INV>
                <ns0:QTY_2>
                  <ns0:C186_2>
                    <C18601>
                      <xsl:choose>
                        <xsl:when test="../../s0:StatusCode='50-QUARANTAINE'">47E</xsl:when>
                        <xsl:when test="../../s0:StatusCode='90-GEBLOKKEERD'">48E</xsl:when>
                        <xsl:otherwise>145</xsl:otherwise>
                      </xsl:choose>
                    </C18601>
                    <C18602>
                      <xsl:value-of select="sum(key('Group-by-MATNO-THT-BATCH-STATUS',$LineKey)/s0:Quantity)" />
                    </C18602>
                    <C18603>EDU</C18603>
                  </ns0:C186_2>
                </ns0:QTY_2>
                <ns0:GIN_2>
                  <GIN01>BX</GIN01>
                  <ns0:C208_6>
                    <C20801>
                      <xsl:value-of select="substring(translate(s0:ExBatchNo, '~', ''), 1, 10)"/>
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
                      <xsl:value-of select="MyScript:ParseDate(s0:ExpirationDate, 'yyyy-MM-dd', 'yyyyMMdd')" />
                    </C50702>
                    <C50703>102</C50703>
                  </ns0:C507_8>
                </ns0:DTM_8>
              </ns0:INVLoop1>
            </ns0:LINLoop1>
          </xsl:if>
        </xsl:if>
      </xsl:for-each>
    </ns0:EFACT_D16B_INVRPT>
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
      
      public string Replace(string input, string toReplace, string replaceTo)
			{
				return input.Replace(toReplace,replaceTo);
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
      
      public string ConvertReasonCode(string Reason)
	    {  
		    switch (Reason)
		    {
			    case "180":
				    return "73";
				    break;

			    case "201":
				    return "73";
				    break;

			    case "206":
				    return "73";
				    break;

			    case "207":
				    return "73";
				    break;

			    case "210":
				    return "73";
				    break;

			    case "212":
				    return "73";
				    break;

			    case "215":
				    return "73";
				    break;

			    case "220":
				    return "73";
				    break;

			    case "221":
				    return "194/195";
				    break;

			    case "222":
				    return "194/195";
				    break;

			    case "223":
				    return "194/195";
				    break;

			    case "224":
				    return "194/195";
				    break;

			    case "225":
				    return "73";
				    break;

			    case "227":
				    return "195";
				    break;

			    case "229":
				    return "";
				    break;

			    case "233":
				    return "195";
				    break;

			    case "234":
				    return "";
				    break;

			    case "241":
				    return "194";
				    break;

			    case "247":
				    return "194";
				    break;

			    case "248":
				    return "194";
				    break;

			    case "261":
				    return "195";
				    break;

			    case "262":
				    return "195";
				    break;

			    case "265":
				    return "73";
				    break;

			    case "266":
				    return "73";
				    break;

			    case "267":
				    return "73";
				    break;

			    case "268":
				    return "73";
				    break;

			    case "269":
				    return "73";
				    break;

			    case "271":
				    return "73";
				    break;

			    case "272":
				    return "73";
				    break;

			    case "275":
				    return "73";
				    break;

			    case "300":
				    return "195";
				    break;

			    default:
				    return Reason;
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