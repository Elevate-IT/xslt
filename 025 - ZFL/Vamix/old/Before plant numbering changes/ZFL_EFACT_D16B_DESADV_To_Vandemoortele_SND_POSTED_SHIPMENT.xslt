<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/postedshipment:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
  </xsl:template>
  <xsl:template match="//s0:Message/s0:Documents/s0:Document">
    <xsl:variable name="Counter" select="position()"></xsl:variable>
    <ns0:EFACT_D16B_DESADV>
      <UNH>
        <UNH1>
          <xsl:value-of select="//s0:Header/s0:MessageID" />
        </UNH1>
        <UNH2>
          <UNH2.1>DESADV</UNH2.1>
          <UNH2.2>D</UNH2.2>
          <UNH2.3>16B</UNH2.3>
          <UNH2.4>UN</UNH2.4>
          <UNH2.5>EAN007</UNH2.5>
        </UNH2>
      </UNH>
      <ns0:BGM>
        <ns0:C002>
          <C00201>351</C00201>
          <C00202>
            <xsl:choose>
              <xsl:when test="s0:Attributes/s0:Attribute[s0:Code='EXTDOC']/s0:Value!=''">
                <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code='EXTDOC']/s0:Value" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="s0:ExternalDocumentNo" />
              </xsl:otherwise>
            </xsl:choose>
          </C00202>
          <C00203>9</C00203>
        </ns0:C002>
      </ns0:BGM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>137</C50701>
          <C50702>
            <xsl:value-of select="MyScript:ParseDate(substring(//s0:CreationDateTime,1,10), 'yyyy-MM-dd', 'yyyyMMdd')" />
          </C50702>
          <C50703>102</C50703>
        </ns0:C507>
      </ns0:DTM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>11</C50701>
          <C50702>
            <xsl:value-of select="MyScript:ParseDate(s0:PostingDate, 'yyyy-MM-dd', 'yyyyMMdd')" />
          </C50702>
          <C50703>102</C50703>
        </ns0:C507>
      </ns0:DTM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>Z01</C50701>
          <C50702>
            <xsl:value-of select="MyScript:ParseDate(s0:OrderDate, 'yyyy-MM-dd', 'yyyyMMdd')" />
          </C50702>
          <C50703>102</C50703>
        </ns0:C507>
      </ns0:DTM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>35</C50701>
          <C50702>
            <xsl:value-of select="MyScript:ParseDate(s0:PostingDate, 'yyyy-MM-dd', 'yyyyMMdd')" />
          </C50702>
          <C50703>102</C50703>
        </ns0:C507>
      </ns0:DTM>
      <ns0:RFFLoop1>
        <ns0:RFF>
          <ns0:C506>
            <C50601>DQ</C50601>
            <C50602>
              <xsl:choose>
                <xsl:when test="s0:Attributes/s0:Attribute[s0:Code='EXTDOC']/s0:Value!=''">
                  <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code='EXTDOC']/s0:Value" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="s0:ExternalDocumentNo" />
                </xsl:otherwise>
              </xsl:choose>
            </C50602>
          </ns0:C506>
        </ns0:RFF>
        <ns0:DTM_2>
          <ns0:C507_2>
            <C50701>171</C50701>
            <C50702>
              <xsl:value-of select="MyScript:ParseDate(s0:PostingDate, 'yyyy-MM-dd', 'yyyyMMddhhmm')" />
            </C50702>
            <C50703>203</C50703>
          </ns0:C507_2>
        </ns0:DTM_2>
      </ns0:RFFLoop1>
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
          <!--<ns0:C080>
            <C08001>Zeebrugge Food Logistics</C08001>
          </ns0:C080>-->
        </ns0:NAD>
      </ns0:NADLoop1>
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>SU</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="//s0:ToTradingPartner" />
            </C08201>
            <C08202>
              <xsl:choose>
                <xsl:when test="s0:Attributes/s0:Attribute[s0:Code='SALESNO']/s0:Value">
                  <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code='SALESNO']/s0:Value" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'0126'" />
                </xsl:otherwise>
              </xsl:choose>
            </C08202>
            <C08203>9</C08203>
          </ns0:C082>
          <!--<ns0:C080>
            <C08001>
              <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code='SALESNA']/s0:Value" />
            </C08001>
          </ns0:C080>-->
        </ns0:NAD>
      </ns0:NADLoop1>
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>DP</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="s0:ShipToAddress/s0:ExternalNo" />
            </C08201>
            <C08203>91</C08203>
          </ns0:C082>
          <ns0:C080>
            <C08001>
              <xsl:value-of select="MyScript:ToUpper(s0:ShipToAddress/s0:Name)" />
            </C08001>
          </ns0:C080>
        </ns0:NAD>
      </ns0:NADLoop1>
      <ns0:CPSLoop1>
        <ns0:CPS>
          <CPS01>
            <xsl:value-of select="MyScript:GetNRCounter(1)"/>
          </CPS01>
        </ns0:CPS>
        <ns0:PACLoop1>
          <ns0:PAC>
            <PAC01>
              <xsl:value-of select="s0:CarrierQuantity"/>
            </PAC01>
            <ns0:C531>
            </ns0:C531>
            <ns0:C202>
              <C20201>201</C20201>
            </ns0:C202>
          </ns0:PAC>
          <ns0:MEA_3>
            <MEA01>PD</MEA01>
            <ns0:C502_3>
              <C50201>AAC</C50201>
            </ns0:C502_3>
            <ns0:C174_3>
              <C17401>KGM</C17401>
              <C17402>
                <xsl:value-of select="format-number(s0:GrossWeight,'#.###')" />
              </C17402>
            </ns0:C174_3>
          </ns0:MEA_3>
        </ns0:PACLoop1>
      </ns0:CPSLoop1>

      <xsl:for-each select="//s0:Carriers/s0:Carrier">
        <xsl:variable name="CarrierNo" select="s0:No" />

        <ns0:CPSLoop1>
          <ns0:CPS>
            <CPS01>
              <xsl:value-of select="MyScript:GetNRCounter(1)" />
            </CPS01>
            <CPS02>
              <xsl:value-of select="MyScript:GetNRCounter2(0)"/>
            </CPS02>
          </ns0:CPS>
          <ns0:PACLoop1>
            <ns0:PAC>
              <PAC01>1</PAC01>
              <ns0:C202>
                <C20201>201</C20201>
                <C20204>
                  <xsl:value-of select="format-number(000000000000035470, '000000000000000000')"/>
                </C20204>
              </ns0:C202>
              <ns0:C402>
                <C40201>F</C40201>
                <C40202>
                  <xsl:value-of select="s0:CarrierTypeCode"/>
                </C40202>
              </ns0:C402>
            </ns0:PAC>
            <ns0:MEA_3>
              <MEA01>PD</MEA01>
              <ns0:C502_3>
                <C50201>AAB</C50201>
              </ns0:C502_3>
              <ns0:C174_3>
                <C17401>KGM</C17401>
                <C17402>
                  <xsl:choose>
                    <xsl:when test="s0:GrossWeight!=0">
                      <xsl:value-of select="format-number(s0:GrossWeight,'#.###')" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="format-number(sum(s0:Contents/s0:Content/s0:GrossWeight),'#.###')" />
                    </xsl:otherwise>
                  </xsl:choose>
                </C17402>
              </ns0:C174_3>
            </ns0:MEA_3>
            <ns0:PCILoop1>
              <ns0:PCI>
                <PCI01>33E</PCI01>
              </ns0:PCI>
              <ns0:GINLoop1>
                <ns0:GIN>
                  <GIN01>BJ</GIN01>
                  <ns0:C208_2>
                    <C20801>
                      <xsl:value-of select="s0:No"/>
                    </C20801>
                  </ns0:C208_2>
                </ns0:GIN>
              </ns0:GINLoop1>
            </ns0:PCILoop1>
          </ns0:PACLoop1>
        </ns0:CPSLoop1>

        <xsl:for-each select="s0:Contents/s0:Content">
          <xsl:variable name="DocumentLineNo" select="s0:DocumentLineNo" />
          <xsl:variable name="LineNo" select="//s0:DocumentLine[s0:LineNo=$DocumentLineNo]/s0:Attributes/s0:Attribute[s0:Code='LINENO']/s0:Value" />

          <ns0:CPSLoop1>
            <ns0:CPS>
              <CPS01>
                <xsl:value-of select="MyScript:GetNRCounter(1)" />
              </CPS01>
              <CPS02>
                <xsl:value-of select="MyScript:GetNRCounter3(0)"/>
              </CPS02>
            </ns0:CPS>
            <ns0:PACLoop1>
              <ns0:PAC>
                <PAC01>
                  <xsl:value-of select="s0:Quantity"/>
                </PAC01>
                <ns0:C202>
                  <C20201>
                    <xsl:choose>
                      <xsl:when test="s0:UnitofMeasureCode !='CRT'">
                        <xsl:value-of select="s0:UnitofMeasureCode"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="'CT'"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </C20201>
                </ns0:C202>
              </ns0:PAC>
            </ns0:PACLoop1>
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
                <PIA01>1</PIA01>
                <ns0:C212_2>
                  <C21201>
                    <xsl:value-of select="format-number($LineNo, '000000')"/>
                  </C21201>
                  <C21202>LI</C21202>
                </ns0:C212_2>
              </ns0:PIA>
              <ns0:PIA>
                <PIA01>5</PIA01>
                <ns0:C212_2>
                  <C21201>
                    <xsl:value-of select="s0:ExternalNo" />
                  </C21201>
                  <C21202>SA</C21202>
                </ns0:C212_2>
              </ns0:PIA>
              <ns0:QTY_3>
                <ns0:C186_3>
                  <C18601>
                    <xsl:value-of select="12"/>
                  </C18601>
                  <C18602>
                    <xsl:value-of select="s0:Quantity"/>
                  </C18602>
                  <C18603>EDU</C18603>
                </ns0:C186_3>
              </ns0:QTY_3>
              <ns0:LOCLoop2>
                <ns0:LOC_4>
                  <LOC01>18</LOC01>
                  <ns0:C517_4>
                    <C51701>0172</C51701>
                    <C51703>91</C51703>
                  </ns0:C517_4>
                  <ns0:C519_4>
                    <C51901>0101</C51901>
                    <C51903>91</C51903>
                  </ns0:C519_4>
                </ns0:LOC_4>
              </ns0:LOCLoop2>
              <ns0:PCILoop2>
                <ns0:PCI_2>
                  <PCI01>36E</PCI01>
                </ns0:PCI_2>
                <ns0:GINLoop2>
                  <ns0:GIN_3>
                    <GIN01>BX</GIN01>
                    <ns0:C208_12>
                      <C20801>
                        <xsl:value-of select="s0:ExternalBatchNo"/>
                      </C20801>
                    </ns0:C208_12>
                  </ns0:GIN_3>
                </ns0:GINLoop2>
              </ns0:PCILoop2>
              <ns0:PCILoop2>
                <ns0:PCI_2>
                  <PCI01>39E</PCI01>
                </ns0:PCI_2>
                <ns0:DTM_10>
                  <ns0:C507_10>
                    <C50701>361</C50701>
                    <C50702>
                      <xsl:value-of select="MyScript:ParseDate(s0:ExpirationDate, 'yyyy-MM-dd', 'yyyyMMdd')" />
                    </C50702>
                    <C50703>102</C50703>
                  </ns0:C507_10>
                </ns0:DTM_10>
              </ns0:PCILoop2>
            </ns0:LINLoop1>
          </ns0:CPSLoop1>
        </xsl:for-each>
      </xsl:for-each>

      <xsl:if test="count(//s0:DocumentLine[s0:Type=1][string-length(s0:QtyPosted)=0])&gt;0">
        <ns0:CPSLoop1>
          <ns0:CPS>
            <CPS01>
              <xsl:value-of select="MyScript:GetNRCounter(1)" />
            </CPS01>
            <CPS02>
              <xsl:value-of select="MyScript:GetNRCounter2(0)"/>
            </CPS02>
          </ns0:CPS>
          <ns0:PACLoop1>
            <ns0:PAC>
              <PAC01>1</PAC01>
              <ns0:C202>
                <C20201>201</C20201>
              </ns0:C202>
              <ns0:C402>
                <C40201>F</C40201>
              </ns0:C402>
            </ns0:PAC>
            <ns0:MEA_3>
              <MEA01>PD</MEA01>
              <ns0:C502_3>
                <C50201>AAB</C50201>
              </ns0:C502_3>
              <ns0:C174_3>
                <C17401>KGM</C17401>
                <C17402 />
              </ns0:C174_3>
            </ns0:MEA_3>
            <ns0:PCILoop1>
              <ns0:PCI>
                <PCI01>33E</PCI01>
              </ns0:PCI>
              <ns0:GINLoop1>
                <ns0:GIN>
                  <GIN01>BJ</GIN01>
                  <ns0:C208_2>
                    <C20801>000000000000000000</C20801>
                  </ns0:C208_2>
                </ns0:GIN>
              </ns0:GINLoop1>
            </ns0:PCILoop1>
          </ns0:PACLoop1>
        </ns0:CPSLoop1>

        <xsl:for-each select="//s0:DocumentLine[s0:Type=1][string-length(s0:QtyPosted)=0]">
          <ns0:CPSLoop1>
            <ns0:CPS>
              <CPS01>
                <xsl:value-of select="MyScript:GetNRCounter(1)" />
              </CPS01>
              <CPS02>
                <xsl:value-of select="MyScript:GetNRCounter3(0)"/>
              </CPS02>
            </ns0:CPS>
            <ns0:PACLoop1>
              <ns0:PAC>
                <PAC01>0</PAC01>
                <ns0:C202>
                  <C20201>
                    <xsl:choose>
                      <xsl:when test="s0:UnitofMeasureCode !='CRT'">
                        <xsl:value-of select="s0:UnitofMeasureCode"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="'CT'"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </C20201>
                </ns0:C202>
              </ns0:PAC>
            </ns0:PACLoop1>
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
                <PIA01>1</PIA01>
                <ns0:C212_2>
                  <C21201>
                    <xsl:value-of select="format-number(s0:Attributes/s0:Attribute[s0:Code='LINENO']/s0:Value, '000000')"/>
                  </C21201>
                  <C21202>LI</C21202>
                </ns0:C212_2>
              </ns0:PIA>
              <ns0:PIA>
                <PIA01>5</PIA01>
                <ns0:C212_2>
                  <C21201>
                    <xsl:value-of select="s0:ExternalNo" />
                  </C21201>
                  <C21202>SA</C21202>
                </ns0:C212_2>
              </ns0:PIA>
              <ns0:QTY_3>
                <ns0:C186_3>
                  <C18601>
                    <xsl:value-of select="12"/>
                  </C18601>
                  <C18602>0</C18602>
                  <C18603>EDU</C18603>
                </ns0:C186_3>
              </ns0:QTY_3>
              <ns0:LOCLoop2>
                <ns0:LOC_4>
                  <LOC01>18</LOC01>
                  <ns0:C517_4>
                    <C51701>0172</C51701>
                    <C51703>91</C51703>
                  </ns0:C517_4>
                  <ns0:C519_4>
                    <C51901>0101</C51901>
                    <C51903>91</C51903>
                  </ns0:C519_4>
                </ns0:LOC_4>
              </ns0:LOCLoop2>
              <ns0:PCILoop2>
                <ns0:PCI_2>
                  <PCI01>36E</PCI01>
                </ns0:PCI_2>
                <ns0:GINLoop2>
                  <ns0:GIN_3>
                    <GIN01>BX</GIN01>
                    <ns0:C208_12>
                      <C20801>DUMMY</C20801>
                    </ns0:C208_12>
                  </ns0:GIN_3>
                </ns0:GINLoop2>
              </ns0:PCILoop2>
              <ns0:PCILoop2>
                <ns0:PCI_2>
                  <PCI01>39E</PCI01>
                </ns0:PCI_2>
                <ns0:DTM_10>
                  <ns0:C507_10>
                    <C50701>361</C50701>
                    <C50702>99991231</C50702>
                    <C50703>102</C50703>
                  </ns0:C507_10>
                </ns0:DTM_10>
              </ns0:PCILoop2>
            </ns0:LINLoop1>
          </ns0:CPSLoop1>
        </xsl:for-each>
      </xsl:if>

    </ns0:EFACT_D16B_DESADV>
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
        else {
          NRCounter2 = 1;
          NRCounter3 = NRCounter;
        }
          
        return (NRCounter2).ToString();
      }
      
      public int NRCounter3;
      public string GetNRCounter3(bool increment)
      {
        if (increment){
          NRCounter3 = NRCounter - 1;
        }
          
        return (NRCounter3).ToString();
      }
            
      public int NRCounter = 0;
      public string GetNRCounter(bool increment)
      {
        if (increment){
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