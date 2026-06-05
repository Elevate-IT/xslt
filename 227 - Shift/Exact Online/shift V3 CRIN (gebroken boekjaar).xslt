<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:userCSharp="http://schemas.microsoft.com/BizTalk/2003/userCSharp"
  xmlns:s0="www.boltrics.nl/sendcreditinvoiceledger:v1.00"
	exclude-result-prefixes = "userCSharp msxsl xsl" >
	<xsl:output method="xml" indent="yes" version="1.0" />

	<xsl:variable name="test" select="/s0:Message/s0:CreditInvoices/s0:CreditInvoice/s0:CustomerLedgerEntries[1]/s0:CustLedgerEntry[1]/s0:Amount[1]" />
	<xsl:variable name="TransactionType">
		<xsl:choose>
			<xsl:when test="substring($test,1,1) = '-'">
				<xsl:text>21</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>20</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="DocumentType">
		<xsl:choose>
			<xsl:when test="substring($test,1,1) = '-'">
				<xsl:text>20</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>10</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:apply-templates select="/" />
	</xsl:template>
	<xsl:template match="/">
		<xsl:for-each select="//s0:Message/s0:CreditInvoices/s0:CreditInvoice">
			<eExact  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:s0="www.boltrics.nl/sendcreditinvoiceledger:v1.00">
				<GLTransactions>
					<xsl:for-each select="s0:GLEntries/s0:GLEntry" >
						<xsl:if test="string-length(s0:GenProdPostingGroup)&gt;0 and string-length(s0:GenBusPostingGroup)&gt;0">
							<xsl:choose>
								<xsl:when test="s0:Amount=0" >
									<xsl:choose>
										<xsl:when test="s0:VATAmount=0">
											<xsl:choose>
												<xsl:when test="(s0:CreditAmount)&gt;0">
													<xsl:value-of select="userCSharp:AddAccount(concat(s0:GLAccountNo,s0:VATProdPostingGroup,s0:Description,s0:WMSPostingDate,s0:StorageDateBegin),0,s0:CreditAmount,0)"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="userCSharp:AddAccount(concat(s0:GLAccountNo,s0:VATProdPostingGroup,s0:Description,s0:WMSPostingDate,s0:StorageDateBegin),0,(-1 * s0:DebitAmount),0)"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="(s0:CreditAmount)&gt;0">
													<xsl:value-of select="userCSharp:AddAccount(concat(s0:GLAccountNo,s0:VATProdPostingGroup,s0:Description,s0:WMSPostingDate,s0:StorageDateBegin),0,s0:CreditAmount,(-1 * s0:VATAmount))"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="userCSharp:AddAccount(concat(s0:GLAccountNo,s0:VATProdPostingGroup,s0:Description,s0:WMSPostingDate,s0:StorageDateBegin),0,(-1 * s0:DebitAmount),(s0:VATAmount))"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>

									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="s0:VATAmount=0">
											<xsl:choose>
												<xsl:when test="(s0:CreditAmount)&gt;0">
													<xsl:value-of select="userCSharp:AddAccount(concat(s0:GLAccountNo,s0:VATProdPostingGroup,s0:Description,s0:WMSPostingDate,s0:StorageDateBegin),(-1 * s0:Amount),s0:CreditAmount,0)"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="userCSharp:AddAccount(concat(s0:GLAccountNo,s0:VATProdPostingGroup,s0:Description,s0:WMSPostingDate,s0:StorageDateBegin),(s0:Amount),(-1 * s0:DebitAmount),0)"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="(s0:CreditAmount)&gt;0">
													<xsl:value-of select="userCSharp:AddAccount(concat(s0:GLAccountNo,s0:VATProdPostingGroup,s0:Description,s0:WMSPostingDate,s0:StorageDateBegin),(-1 * s0:Amount),s0:CreditAmount,(-1 * s0:VATAmount))"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="userCSharp:AddAccount(concat(s0:GLAccountNo,s0:VATProdPostingGroup,s0:Description,s0:WMSPostingDate,s0:StorageDateBegin),(s0:Amount),(-1 * s0:DebitAmount),(-1 * s0:VATAmount))"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:for-each>
					<GLTransaction>
						<xsl:attribute name="entry">
							<xsl:value-of select="translate(s0:No,translate(s0:No,'0123456789',''),'')"/>
						</xsl:attribute>
						<!--<TransactionType number="{$TransactionType}">
              <Description>Sales entry</Description>
            </TransactionType>-->
						<Journal>
							<xsl:attribute name="code" >709</xsl:attribute>
							<!--<xsl:attribute name="type" >20</xsl:attribute>-->
							<!--<Description>Verkoopdagboek</Description>-->
							<!--<GLAccount>
                <xsl:attribute name="code">
                  <xsl:text>400000</xsl:text>
                </xsl:attribute>
                -->
							<!--<xsl:attribute name="type" >
                  <xsl:text>20</xsl:text>
                </xsl:attribute>-->
							<!--
              </GLAccount>-->
						</Journal>
						<xsl:if test="string-length(s0:Customer/s0:PaymentTermsCode)&gt;0" >
							<PaymentCondition>
								<xsl:attribute name="code">
									<xsl:value-of select="s0:Customer/s0:PaymentTermsCode"/>
								</xsl:attribute>
								<!--<Description>
                  <xsl:value-of select="s0:Customer/s0:PaymentTermsCode"/>
                </Description>-->
							</PaymentCondition>
						</xsl:if>
						<Date>
							<xsl:value-of select="userCSharp:GetCurrentDate('yyyy-MM-dd')" />
						</Date>
						<xsl:variable name="FinYear" select="substring(s0:DocumentDate,1,4)" />
						<xsl:variable name="FinPeriod" select="number(substring(s0:DocumentDate,6,2))" />
						<xsl:choose>
							<xsl:when test="$FinYear = '2024'">
								<xsl:choose>
									<xsl:when test="$FinPeriod &lt; 10">
										<FinYear>
											<xsl:attribute name="number">
												<xsl:value-of select="2023"/>
											</xsl:attribute>
										</FinYear>
										<FinPeriod>
											<xsl:attribute name="number">
												<xsl:value-of select="$FinPeriod + 12"/>
											</xsl:attribute>
										</FinPeriod>
									</xsl:when>
									<xsl:otherwise>
										<FinYear>
											<xsl:attribute name="number">
												<xsl:value-of select="2025"/>
											</xsl:attribute>
										</FinYear>
										<FinPeriod>
											<xsl:attribute name="number">
												<xsl:text>0</xsl:text>
												<xsl:value-of select="$FinPeriod - 9"/>
											</xsl:attribute>
										</FinPeriod>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>

							<xsl:when test="$FinYear = '2025'">


								<xsl:choose>
									<xsl:when test="$FinPeriod &lt; 7">
										<FinYear>
											<xsl:attribute name="number">
												<xsl:value-of select="$FinYear"/>
											</xsl:attribute>
										</FinYear>
										<FinPeriod>
											<xsl:attribute name="number">
												<xsl:text>0</xsl:text>
												<xsl:value-of select="$FinPeriod + 3"/>
											</xsl:attribute>
										</FinPeriod>
									</xsl:when>
									<xsl:otherwise>
										<FinYear>
											<xsl:attribute name="number">
												<xsl:value-of select="$FinYear"/>
											</xsl:attribute>
										</FinYear>
										<FinPeriod>
											<xsl:attribute name="number">
												<xsl:value-of select="$FinPeriod + 3"/>
											</xsl:attribute>
										</FinPeriod>
									</xsl:otherwise>
								</xsl:choose>

							</xsl:when>
							<xsl:otherwise>
								<FinYear>
									<xsl:attribute name="number">
										<xsl:value-of select="substring(s0:DocumentDate,1,4)"/>
									</xsl:attribute>
								</FinYear>
								<FinPeriod>
									<xsl:attribute name="number">
										<xsl:value-of select="substring(s0:DocumentDate,6,2)"/>
									</xsl:attribute>
								</FinPeriod>
							</xsl:otherwise>
						</xsl:choose>
						<Document>
							<Subject>
								<xsl:value-of select="concat('Invoice: ',s0:GLEntries/s0:GLEntry[1]/s0:WMSDocumentNo)"/>
							</Subject>
							<!--<Description>
                <xsl:value-of select="concat(s0:Customer/s0:Name,' ',s0:No)"/>
              </Description>-->
							<DocumentType number="{$DocumentType}">
								<!--<Description>Sales Invoice</Description>-->
							</DocumentType>
							<!--<Account>
                <xsl:attribute name="code">
                  <xsl:value-of select="s0:Customer/s0:No"/>
                </xsl:attribute>
              </Account>
              <Date>
                <xsl:value-of  select="s0:PostingDate"/>
              </Date>
              <References>
                <Sales>
                  <InvoiceNumber>
                    <xsl:value-of select="s0:No"/>
                  </InvoiceNumber>
                </Sales>
                <YourRef>
                  <xsl:value-of select="s0:No"/>
                </YourRef>
              </References>-->
							<Attachments>
								<xsl:choose>
									<xsl:when test="count(s0:LinkedDocuments/s0:LinkedDocument)=0">
										<Attachment>
											<Name>
											</Name>
											<BinaryData>
											</BinaryData>
										</Attachment>
									</xsl:when>
									<xsl:otherwise>
										<xsl:for-each select="s0:LinkedDocuments/s0:LinkedDocument">
											<Attachment>
												<Name>
													<xsl:value-of select="s0:Description" />
												</Name>
												<BinaryData>
													<xsl:value-of select="s0:EncodedPDF"/>
												</BinaryData>
											</Attachment>
										</xsl:for-each>
									</xsl:otherwise>
								</xsl:choose>
							</Attachments>
						</Document>
						<Account>
							<xsl:attribute name="code">
								<xsl:value-of select="translate(//s0:Customer/s0:No,translate(//s0:Customer/s0:No,'0123456789',''),'')" />
							</xsl:attribute>
							<Name>
								<xsl:value-of select="//s0:Customer/s0:Name" />
							</Name>
							<xsl:if test="string-length(//s0:Customer/s0:PhoneNo)&gt;0">
								<Phone>
									<xsl:value-of select="//s0:Customer/s0:PhoneNo"/>
								</Phone>
							</xsl:if>
							<xsl:if test="string-length(//s0:Customer/s0:E-Mail)&gt;0">
								<Email>
									<xsl:value-of select="//s0:Customer/s0:E-Mail"/>
								</Email>
							</xsl:if>
							<xsl:if test="string-length(//s0:Customer/s0:HomePage)&gt;0">
								<HomePage>
									<xsl:value-of select="//s0:Customer/s0:HomePage"/>
								</HomePage>
							</xsl:if>
							<Address>
								<AddressLine1>
									<xsl:value-of select="//s0:Customer/s0:Address"/>
								</AddressLine1>
								<xsl:if test="string-length(//s0:Customer/s0:Address2)&gt;0">
									<AddressLine2>
										<xsl:value-of select="//s0:Customer/s0:Address2"/>
									</AddressLine2>
								</xsl:if>
								<xsl:if test="string-length(//s0:Customer/s0:AddressNo)&gt;0">
									<AddressNo>
										<xsl:value-of select="//s0:Customer/s0:AddressNo"/>
									</AddressNo>
								</xsl:if>
								<xsl:if test="string-length(//s0:Customer/s0:PostCode)&gt;0">
									<PostalCode>
										<xsl:value-of select="//s0:Customer/s0:PostCode"/>
									</PostalCode>
								</xsl:if>
								<City>
									<xsl:value-of select="//s0:Customer/s0:City"/>
								</City>
								<Country>
									<xsl:attribute name="code">
										<xsl:value-of select="//s0:Customer/s0:CountryRegionCode"/>
									</xsl:attribute>
								</Country>
							</Address>
							<VATNumber>
								<xsl:value-of select="//s0:Customer/s0:VATRegistrationNo"/>
							</VATNumber>
						</Account>
						<xsl:for-each select="s0:GLEntries/s0:GLEntry">
							<GLTransactionLine>
								<xsl:attribute name="line">21</xsl:attribute>
								<Date>
									<xsl:value-of select="s0:DocumentDate" />
								</Date>
								<FinYear>
									<xsl:attribute name="number">
										<xsl:value-of select="substring(s0:DocumentDate,1,4)"/>
									</xsl:attribute>
								</FinYear>
								<FinPeriod>
									<xsl:attribute name="number">
										<xsl:value-of select="substring(s0:DocumentDate,6,2)"/>
									</xsl:attribute>
								</FinPeriod>
								<GLAccount>
									<xsl:attribute name="code">
										<xsl:value-of select="s0:GLAccountNo" />
									</xsl:attribute>
								</GLAccount>
								<xsl:choose>
									<xsl:when test="s0:GLAccountNo = '700100'">
										<Description>
											<xsl:value-of select="s0:WMSDocumentNo"/>
										</Description>
									</xsl:when>
									<xsl:otherwise>
										<Description>
											<xsl:value-of select="//s0:GLEntry[1]/s0:WMSDocumentNo"/>
										</Description>
									</xsl:otherwise>
								</xsl:choose>
								<DueDate>
									<xsl:value-of select="//s0:DueDate"/>
								</DueDate>
								<InvoiceDate>
									<xsl:value-of select="//s0:DocumentDate"/>
								</InvoiceDate>
								<Account>
									<xsl:attribute name="code">
										<xsl:value-of select="//s0:Customer/s0:No" />
									</xsl:attribute>
									<Name>
										<xsl:value-of select="//s0:Customer/s0:Name" />
									</Name>
								</Account>

								<!--<xsl:if test="s0:GlobalDimension1Code">
                  <Costcenter>
                    <xsl:attribute name="code" >
                      <xsl:value-of select="s0:GlobalDimension1Code"/>
                    </xsl:attribute>
                  </Costcenter>
                </xsl:if>
                <xsl:if test="s0:GlobalDimension2Code">
                  <Costunit>
                    <xsl:attribute name="code" >
                      <xsl:value-of select="s0:GlobalDimension2Code"/>
                    </xsl:attribute>
                  </Costunit>
                </xsl:if>-->
								<Amount>
									<Currency>
										<xsl:attribute name="code" >
											<xsl:value-of select="//s0:CreditInvoices/s0:CreditInvoice/s0:CurrencyCode"/>
										</xsl:attribute>
									</Currency>
									<Value>
										<xsl:value-of select="s0:Amount"/>
									</Value>
									<xsl:if test="string-length(s0:VATClauseCode)&gt;0">
										<VAT>
											<xsl:attribute name="code" >
												<xsl:value-of select="s0:VATClauseCode"/>
											</xsl:attribute>
										</VAT>
									</xsl:if>
									<!--<xsl:if test="translate(userCSharp:GetVATAmount(concat(s0:GLAccountNo,s0:VATProdPostingGroup,s0:Description,s0:WMSPostingDate,s0:StorageDateBegin)),',','.')&gt;0" >-->
									<!--<VATBaseAmount>
                      <xsl:value-of select="translate(userCSharp:GetAccountAmount(concat(s0:GLAccountNo,s0:VATProdPostingGroup,s0:Description,s0:WMSPostingDate,s0:StorageDateBegin)),',','.')"/>
                    </VATBaseAmount>-->
									<!--</xsl:if>-->
								</Amount>
								<ForeignAmount>
									<Currency>
										<xsl:attribute name="code" >
											<xsl:value-of select="//s0:CreditInvoices/s0:CreditInvoice/s0:CurrencyCode"/>
										</xsl:attribute>
									</Currency>
									<Value>
										<xsl:value-of select="s0:Amount"/>
									</Value>
									<Rate>
										<xsl:text>1.000000</xsl:text>
									</Rate>
								</ForeignAmount>
								<References>
									<InvoiceNumber>
										<xsl:value-of select="//s0:No"/>
									</InvoiceNumber>
									<PaymentReference>
										<xsl:value-of select="//s0:No"/>
									</PaymentReference>
									<YourRef>
										<xsl:value-of select="//s0:No"/>
									</YourRef>
								</References>
								<!--                 <xsl:variable name="InvoicePeriod" select="substring(s0:PostingDate,6,2)"/>
                <xsl:variable name="WMSPeriod" select="substring(s0:WMSPostingDate,6,2)"/>
                <xsl:variable name="StoragePeriod" select="substring(s0:StorageDateBegin,6,2)"/>
                <xsl:if test="(($InvoicePeriod!=$WMSPeriod) and (string-length($WMSPeriod)&gt;0)) or (($InvoicePeriod!=$StoragePeriod) and (string-length($StoragePeriod)&gt;0))">
                  <DeferredFrom>
                    <xsl:value-of select="s0:WMSPostingDate" />
                    <xsl:value-of select="s0:StorageDateBegin" />
                  </DeferredFrom>
                  <DeferredTo>
                    <xsl:value-of select="s0:WMSPostingDate" />
                    <xsl:value-of select="s0:StorageDateBegin" />
                  </DeferredTo>
                </xsl:if> -->
							</GLTransactionLine>
						</xsl:for-each>
					</GLTransaction>
				</GLTransactions>
			</eExact>
		</xsl:for-each>

		<!-- -->
	</xsl:template>
	<msxsl:script language="C#" implements-prefix="userCSharp">
		<![CDATA[
      public int counter = 0;
      public string GetLinCounter()
      {
          counter = counter + 1;
          return counter.ToString();
      }

      public int counterLine = 0;
      public string GetLinCounterLine()
      {
          counterLine = counterLine + 1;
          return counterLine.ToString();
      }
		
		  public string GetCurrentDate(string formatOut)
		  {
			return System.DateTime.Now.ToString(formatOut);
		  }
		  public string GetTimeAndSecond()
		  {
			return System.DateTime.Now.ToString("HHmmssMM");
		  }  
	  
		  public string GetTime()
		  {
			return System.DateTime.Now.ToString("HHmm");
		  }
		  
		  public string GetDateTime()
		  {
			return System.DateTime.Now.ToString("yyyyMMddHHmm");
		  }
		  
		   public string ParseDate(string input, string formatIn, string formatOut)
		  {
			DateTime dateT = DateTime.ParseExact(input, formatIn, null);
			return dateT.ToString(formatOut);
		  }

      public string GetVATTypeNL(string VATCode)
	    {  
		    switch (VATCode)
		    {
			    case "0" : 
				    return "0";
				    break;
			    case "21" : 
				    return "2";
				    break;  
			    case "9" : 
				    return "20";
				    break;  				
			    default:
				    return VATCode;
		    }       
      }	

      public string GetVATTypeEU(string VATCode)
	    {  
		    switch (VATCode)
		    {
			    case "0" : 
				    return "0";
				    break;
			    case "21" : 
				    return "30";
				    break;  
			    case "9" : 
				    return "30";
				    break;  				
			    default:
				    return VATCode;
		    }       
      }	

      public string GetVATTypeEX(string VATCode)
	    {  
		    switch (VATCode)
		    {
			    case "21" : 
				    return "0";
				    break;
			    case "0" : 
				    return "0";
				    break;
			    case "9" : 
				    return "0";
				    break;
            
			    default:
				    return VATCode;
		    }       
      }	


      static System.Collections.Generic.List<Account> accountList = new System.Collections.Generic.List<Account>();

        public class Account
        {
            public string AccountNumber { get; set; }
            public decimal AccountAmount { get; set; }
            public decimal CreditDebitAmount { get; set; }
            public decimal VATAmount { get; set; }
        }

        public static void AddAccount(string AccountNumber, string AccountAmount, string CreditDebitAmount, string VATAmount)
        {            
            decimal accountAmount = 0;
            decimal creditdebitAmount = 0;
            decimal vatAmount = 0;

            var found = false;

            System.Globalization.CultureInfo culInfo = new System.Globalization.CultureInfo("en-GB",true);
            accountAmount = decimal.Parse(AccountAmount,culInfo);
            creditdebitAmount = decimal.Parse(CreditDebitAmount,culInfo);
            vatAmount = decimal.Parse(VATAmount,culInfo);

            foreach (var account in accountList)
            {
                if (account.AccountNumber == AccountNumber)
                {
                    account.AccountAmount = account.AccountAmount + accountAmount;
                    account.CreditDebitAmount = account.CreditDebitAmount + creditdebitAmount;
                    account.VATAmount = account.VATAmount + vatAmount;
                    found = true;
                }
            }
            
            if (! found)
            {
                var account = new Account()
                {
                    AccountNumber = AccountNumber,
                    AccountAmount = accountAmount,
                    CreditDebitAmount = creditdebitAmount,
                    VATAmount = vatAmount
                };

                accountList.Add(account);
            }
        }


        public static string GetAccountAmount(string AccountNumber)
        {
            foreach (var account in accountList)
            {
                if (account.AccountNumber == AccountNumber)
                {
                    return account.AccountAmount.ToString();
                }
            }
            return null;            
        }

        public static string GetCreditDebitAmount(string AccountNumber)
        {
            foreach (var account in accountList)
            {
                if (account.AccountNumber == AccountNumber)
                {
                    return account.CreditDebitAmount.ToString();
                }
            }
            return null;            
        }
        public static string GetVATAmount(string AccountNumber)
        {
            foreach (var account in accountList)
            {
                if (account.AccountNumber == AccountNumber)
                {
                    return account.VATAmount.ToString();
                }
            }
            return null;            
        }
      
	]]>
	</msxsl:script>
</xsl:stylesheet>