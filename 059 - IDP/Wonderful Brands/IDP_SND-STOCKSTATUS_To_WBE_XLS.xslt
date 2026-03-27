<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/stockstatus:v1.00"
                xmlns:x="urn:schemas-microsoft-com:office:excel"
                xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0">
  <xsl:output omit-xml-declaration="no" indent="yes"/>

  <xsl:key name="Group-by-No" match="//s0:Carrier" use="s0:No" />
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Customers/s0:Customer" />
  </xsl:template>
  <xsl:template match="//s0:Message/s0:Customers/s0:Customer">
    <xsl:variable name="DetLineKey" select="//s0:Carrier/s0:No" />
    <xsl:processing-instruction name="mso-application">progid="Excel.Sheet"</xsl:processing-instruction>
    <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">
      <Styles>
        <Style ss:ID="header" ss:Name="Normal">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
        </Style>
        <Style ss:ID="s1">
          <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
          <Font ss:FontName="Calibri" ss:Size="12" ss:Bold="1"/>
        </Style>
        <Style ss:ID="s2">
          <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
          <Borders>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="10" ss:Bold="1"/>
        </Style>
        <Style ss:ID="s3">
          <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
          <Borders>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="10" ss:Bold="1"/>
        </Style>
        <Style ss:ID="s4">
          <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
          <Borders>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="10" ss:Bold="1"/>
        </Style>
        <Style ss:ID="s5">
          <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
          <Borders>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="10" ss:Bold="1"/>
        </Style>
        <Style ss:ID="s6">
          <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
          <Borders>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="10" ss:Bold="1"/>
        </Style>
        <Style ss:ID="s7">
          <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
          <Borders>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="10" ss:Bold="1"/>
        </Style>
        <Style ss:ID="s8">
          <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
          <Borders>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="11"/>
          <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>
        </Style>
        <Style ss:ID="s9">
          <Alignment ss:Horizontal="Right" ss:Vertical="Center"/>
          <Borders>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="11"/>
          <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>
        </Style>
        <Style ss:ID="s10">
          <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
          <Borders>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="10"/>
        </Style>
      </Styles>
      <Worksheet ss:Name="Stock Status">
        <Table>
          <Column ss:Index="1" ss:Width="96"/>
          <Column ss:Index="2" ss:Width="183"/>
          <Column ss:Index="3" ss:Width="54"/>
          <Column ss:Index="4" ss:Width="53"/>
          <Column ss:Index="5" ss:Width="53"/>
          <Column ss:Index="6" ss:Width="99"/>
          <Column ss:Index="7" ss:Width="34"/>
          <Column ss:Index="8" ss:Width="37"/>
          <Column ss:Index="9" ss:Width="43"/>
          <Column ss:Index="10" ss:Width="37"/>
          <Column ss:Index="11" ss:Width="43"/>
          <Row ss:Index="1">
            <Cell ss:Index="1" ss:StyleID="s1">
              <Data ss:Type="String">Per Pallet</Data>
            </Cell>
          </Row>
          <Row ss:Index="2">
            <Cell ss:Index="1">
              <Data ss:Type="String">
                <xsl:value-of select="concat('Beginstock ', ' ', translate(MyScript:ParseDate(//s0:Message/s0:Header/s0:CreationDateTime,'yyyy-MM-ddTHH:mm:ss','dd/MM/yyyy'), '-', '/'))" />
              </Data>
            </Cell>
          </Row>
          <Row ss:Index="3">
            <Cell ss:Index="1">
              <Data ss:Type="String">
                <xsl:value-of select="concat('Generated ', ' ', translate(MyScript:ParseDate(//s0:Message/s0:Header/s0:CreationDateTime,'yyyy-MM-ddTHH:mm:ss','dd/MM/yyyy - HH:mm'), '-', '-'))" />
              </Data>
            </Cell>
          </Row>

          <Row ss:Index="5">
            <Cell ss:Index="1" ss:StyleID="s2">
              <Data ss:Type="String">ID 1</Data>
            </Cell>
            <Cell ss:Index="2" ss:StyleID="s3">
              <Data ss:Type="String">ID 2</Data>
            </Cell>
            <Cell ss:Index="3" ss:StyleID="s3">
              <Data ss:Type="String">ID 3</Data>
            </Cell>
            <Cell ss:Index="4" ss:StyleID="s3">
              <Data ss:Type="String">Exp. Date</Data>
            </Cell>
            <Cell ss:Index="5" ss:StyleID="s3">
              <Data ss:Type="String">Date in</Data>
            </Cell>
            <Cell ss:Index="6" ss:StyleID="s3">
              <Data ss:Type="String">SSCC</Data>
            </Cell>
            <Cell ss:Index="7" ss:StyleID="s3">
              <Data ss:Type="String">Cartons</Data>
            </Cell>
            <Cell ss:Index="8" ss:StyleID="s3">
              <Data ss:Type="String">Number</Data>
            </Cell>
            <Cell ss:Index="9" ss:StyleID="s3">
              <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:Index="10" ss:StyleID="s3">
              <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:Index="11" ss:StyleID="s4">
              <Data ss:Type="String"></Data>
            </Cell>
          </Row>
          <Row ss:Index="6">
            <Cell ss:Index="1" ss:StyleID="s5">
              <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:Index="2" ss:StyleID="s6">
              <Data ss:Type="String">EX EAN CODE</Data>
            </Cell>
            <Cell ss:Index="3" ss:StyleID="s6">
              <Data ss:Type="String">-(10)-</Data>
            </Cell>
            <Cell ss:Index="4" ss:StyleID="s6">
              <Data ss:Type="String">-(15)-</Data>
            </Cell>
            <Cell ss:Index="5" ss:StyleID="s6">
              <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:Index="6" ss:StyleID="s6">
              <Data ss:Type="String">-(00)-</Data>
            </Cell>
            <Cell ss:Index="7" ss:StyleID="s6">
              <Data ss:Type="String">-(37)-</Data>
            </Cell>
            <Cell ss:Index="8" ss:StyleID="s6">
              <Data ss:Type="String">Pallet</Data>
            </Cell>
            <Cell ss:Index="9" ss:StyleID="s6">
              <Data ss:Type="String">Reserved</Data>
            </Cell>
            <Cell ss:Index="10" ss:StyleID="s6">
              <Data ss:Type="String">Blocked</Data>
            </Cell>
            <Cell ss:Index="11" ss:StyleID="s7">
              <Data ss:Type="String">Available</Data>
            </Cell>
          </Row>
          <Row ss:Index="7">
            <Cell ss:Index="1" ss:StyleID="s8">
              <Data ss:Type="String">Subtotal Project:</Data>
            </Cell>
            <Cell ss:Index="2" ss:StyleID="s8">
              <Data ss:Type="String">PME, 1 WONDERFUL</Data>
            </Cell>
            <Cell ss:Index="3" ss:StyleID="s8">
              <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:Index="4" ss:StyleID="s8">
              <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:Index="5" ss:StyleID="s8">
              <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:Index="6" ss:StyleID="s8">
              <Data ss:Type="String"></Data>
            </Cell>
            <!--Total Cartons-->
            <Cell ss:Index="7" ss:StyleID="s9">
              <Data ss:Type="Number">
                <xsl:value-of select="sum(//s0:Carrier/s0:ContentLines/s0:CarrierContent/s0:Quantity)" />
              </Data>
            </Cell>
            <!--Total Pallets-->
            <Cell ss:Index="8" ss:StyleID="s9">
              <Data ss:Type="Number">
                <xsl:value-of select="count(//s0:Carrier)" />
              </Data>
            </Cell>
            <!--Total Reserved-->
            <Cell ss:Index="9" ss:StyleID="s9">
              <Data ss:Type="Number">
                <xsl:value-of select="sum(//s0:Carrier/s0:ContentLines/s0:CarrierContent/s0:QuantityOnShipment)"/>
              </Data>
            </Cell>
            <!--Total Blocked-->
            <Cell ss:Index="10" ss:StyleID="s9">
              <Data ss:Type="Number">
                <xsl:value-of select="sum(//s0:Carrier[substring(s0:StatusCode, 1, 8) = '90-BLOCK']/s0:ContentLines/s0:CarrierContent/s0:Quantity)" />
              </Data>
            </Cell>
            <!--Total Available-->
            <Cell ss:Index="11" ss:StyleID="s9">
              <Data ss:Type="Number">
                <xsl:value-of select="sum(//s0:Carrier[substring(s0:StatusCode, 1, 8) != '90-BLOCK']/s0:ContentLines/s0:CarrierContent/s0:Quantity) - sum(//s0:Carrier/s0:ContentLines/s0:CarrierContent/s0:QuantityOnShipment)" />
              </Data>
            </Cell>
          </Row>
          <xsl:for-each select="//s0:Carrier">
            <xsl:variable name="CarrierNo" select="s0:No" />
            <Row>
              <!--ID 1-->
              <Cell ss:Index="1" ss:StyleID="s10">
                <Data ss:Type="String">
                  <xsl:value-of select="s0:ContentLines/s0:CarrierContent/s0:ExternalCustomerItemNo"/>
                </Data>
              </Cell>
              <!--ID 2 (EX EAN CODE)-->
              <Cell ss:Index="2" ss:StyleID="s10">
                <Data ss:Type="String">
                  <xsl:variable name="CustItem">
                    <xsl:value-of select="s0:ContentLines/s0:CarrierContent/s0:CustomerItemNo"/>
                  </xsl:variable>
                  <xsl:for-each select="//s0:Message/s0:Customers/s0:Customer/s0:Items/s0:Item">
                    <xsl:if test="s0:No = $CustItem">
                      <xsl:value-of select="s0:Description"/>
                    </xsl:if>
                  </xsl:for-each>
                </Data>
              </Cell>
              <!--ID 3 (10)-->
              <Cell ss:Index="3" ss:StyleID="s10">
                <Data ss:Type="String">
                  <xsl:value-of select="s0:ContentLines/s0:CarrierContent/s0:ExBatchNo"/>
                </Data>
              </Cell>
              <!--Exp. Date (15)-->
              <Cell ss:Index="4" ss:StyleID="s10">
                <Data ss:Type="String">
                  <xsl:value-of select="translate(MyScript:ParseDate(s0:ContentLines/s0:CarrierContent/s0:ExpirationDate,'yyyy-MM-dd','dd/MM/yyyy'), '-', '/')"/>
                </Data>
              </Cell>
              <!--Date In-->
              <Cell ss:Index="5" ss:StyleID="s10">
                <Data ss:Type="String">
                  <xsl:value-of select="translate(MyScript:ParseDate(s0:ContentLines/s0:CarrierContent/s0:ReceiptDate,'yyyy-MM-dd','dd/MM/yyyy'), '-', '/')"/>
                </Data>
              </Cell>
              <!--SSCC (00)-->
              <Cell ss:Index="6" ss:StyleID="s10">
                <Data ss:Type="String">
                  <xsl:value-of select="s0:No"/>
                </Data>
              </Cell>
              <!--Cartons (37)-->
              <Cell ss:Index="7" ss:StyleID="s10">
                <Data ss:Type="Number">
                  <xsl:value-of select="s0:ContentLines/s0:CarrierContent/s0:Quantity"/>
                </Data>
              </Cell>
              <!--Number Pallet-->
              <Cell ss:Index="8" ss:StyleID="s10">
                <Data ss:Type="Number">
                  <xsl:value-of select="count(//s0:Carrier[s0:No = $CarrierNo])"/>
                </Data>
              </Cell>
              <!--Reserved-->
              <Cell ss:Index="9" ss:StyleID="s10">
                <Data ss:Type="Number">
                  <xsl:value-of select="s0:ContentLines/s0:CarrierContent/s0:QuantityOnShipment"/>
                </Data>
              </Cell>
              <!--Blocked-->
              <Cell ss:Index="10" ss:StyleID="s10">
                <Data ss:Type="Number">
                  <xsl:choose>
                    <xsl:when test="substring(s0:StatusCode, 1, 8) = '90-BLOCK'">
                      <xsl:value-of select="s0:ContentLines/s0:CarrierContent/s0:Quantity"/>
                    </xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                  </xsl:choose>
                </Data>
              </Cell>
              <!--Available-->
              <Cell ss:Index="11" ss:StyleID="s10">
                <Data ss:Type="Number">
                  <xsl:choose>
                    <xsl:when test="substring(s0:StatusCode, 1, 8) = '90-BLOCK'">0</xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="s0:ContentLines/s0:CarrierContent/s0:Quantity - s0:ContentLines/s0:CarrierContent/s0:QuantityOnShipment"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </Data>
              </Cell>
            </Row>
          </xsl:for-each>
          <Row>
            <!--Empty Line-->
            <Cell ss:Index="1" ss:StyleID="s10"/>
            <Cell ss:Index="2" ss:StyleID="s10"/>
            <Cell ss:Index="3" ss:StyleID="s10"/>
            <Cell ss:Index="4" ss:StyleID="s10"/>
            <Cell ss:Index="5" ss:StyleID="s10"/>
            <Cell ss:Index="6" ss:StyleID="s10"/>
            <Cell ss:Index="7" ss:StyleID="s10"/>
            <Cell ss:Index="8" ss:StyleID="s10"/>
            <Cell ss:Index="9" ss:StyleID="s10"/>
            <Cell ss:Index="10" ss:StyleID="s10"/>
            <Cell ss:Index="11" ss:StyleID="s10"/>
          </Row>
          <Row>
            <Cell ss:Index="1" ss:StyleID="s8">
              <Data ss:Type="String">Total all Projects</Data>
            </Cell>
            <Cell ss:Index="2" ss:StyleID="s8">
              <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:Index="3" ss:StyleID="s8">
              <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:Index="4" ss:StyleID="s8">
              <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:Index="5" ss:StyleID="s8">
              <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:Index="6" ss:StyleID="s8">
              <Data ss:Type="String"></Data>
            </Cell>
            <!--Total Cartons-->
            <Cell ss:Index="7" ss:StyleID="s9">
              <Data ss:Type="Number">
                <xsl:value-of select="sum(//s0:Carrier/s0:ContentLines/s0:CarrierContent/s0:Quantity)" />
              </Data>
            </Cell>
            <!--Total Pallets-->
            <Cell ss:Index="8" ss:StyleID="s9">
              <Data ss:Type="Number">
                <xsl:value-of select="count(//s0:Carrier)" />
              </Data>
            </Cell>
            <!--Total Reserved-->
            <Cell ss:Index="9" ss:StyleID="s9">
              <Data ss:Type="Number">
                <xsl:value-of select="sum(//s0:Carrier/s0:ContentLines/s0:CarrierContent/s0:QuantityOnShipment)"/>
              </Data>
            </Cell>
            <!--Total Blocked-->
            <Cell ss:Index="10" ss:StyleID="s9">
              <Data ss:Type="Number">
                <xsl:value-of select="sum(//s0:Carriers/s0:Carrier[substring(s0:StatusCode, 1, 8) = '90-BLOCK']/s0:ContentLines/s0:CarrierContent/s0:Quantity)" />
              </Data>
            </Cell>
            <!--Total Available-->
            <Cell ss:Index="11" ss:StyleID="s9">
              <Data ss:Type="Number">
                <xsl:value-of select="sum(//s0:Carrier[substring(s0:StatusCode, 1, 8) != '90-BLOCK']/s0:ContentLines/s0:CarrierContent/s0:Quantity) - sum(//s0:Carrier/s0:ContentLines/s0:CarrierContent/s0:QuantityOnShipment)" />
              </Data>
            </Cell>
          </Row>
        </Table>
        <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
          <PageSetup>
            <Layout x:Orientation="Landscape"/>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.5" x:Left="0.25" x:Right="0.25" x:Top="0.5"/>
          </PageSetup>
        </WorksheetOptions>
      </Worksheet>
    </Workbook>
  </xsl:template>
  
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			

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
      
      public string TrimEnd(string input)
      {
        return input.TrimEnd();
      }
      
      public int rowNr = 0;
      public string GetRowNr(int offset)
      {
        if (rowNr == 0)
          rowNr += offset;
          
        rowNr += 1;
          
        return rowNr.ToString();
      }
      
      public int QtyUnavailable;
      public int TotalQtyUnavailable;
      public void SetQtyUnavailable(int Qty, string Sign)
      {
        if (string.IsNullOrEmpty(Sign)) 
          QtyUnavailable = Qty;
        else if (Sign == "-") 
        {
          QtyUnavailable -= Qty;
          TotalQtyUnavailable -= Qty;
        }
        else if (Sign == "+")
        {
          QtyUnavailable += Qty;
          TotalQtyUnavailable += Qty;
        }
      }
      
      public string GetQtyUnavailable()
      {
          return QtyUnavailable.ToString();
      }
      
      public string GetTotalQtyUnavailable()
      {
          return TotalQtyUnavailable.ToString();
      }
		]]>
  </msxsl:script>
</xsl:stylesheet>
