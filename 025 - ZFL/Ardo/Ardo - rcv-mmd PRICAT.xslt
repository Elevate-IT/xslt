<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var s0 MyScript"
                xmlns:ns0="www.boltrics.nl/materialmasterdata:v1.00"
                xmlns:s0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                version="3.0">
	<xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
	<xsl:template match="s0:EFACT_D01B_PRODAT">
		<ns0:Message>
			<ns0:Header>
				<ns0:MessageID>
					<xsl:value-of select="UNH/UNH1" />
				</ns0:MessageID>
				<ns0:CreationDateTime>
					<xsl:value-of select="current-dateTime()" />
				</ns0:CreationDateTime>
				<ns0:ProcesAction>
					<xsl:text>INSERT</xsl:text>
				</ns0:ProcesAction>
				<ns0:FromTradingPartner>
					<xsl:value-of select="UNB/UNB2.1"/>
				</ns0:FromTradingPartner>
				<ns0:ToTradingPartner>
					<!-- <xsl:value-of select="UNB/UNB2.2"/> -->
					<xsl:text>Zeebrugge Food Logistics</xsl:text>
				</ns0:ToTradingPartner>
			</ns0:Header>

			<xsl:variable name="QtyBulkTU" select="s0:PGI/s0:C288/C28804"/>

			<ns0:CustomerItems>
				<xsl:for-each select="s0:LINLoop1[s0:LIN/LIN01=1]">
					<ns0:CustomerItem>
						<ns0:ExternalNo>
							<xsl:value-of select="s0:PIA_2/s0:C212_7[C21202='SA']/C21201"/>
						</ns0:ExternalNo>
						<ns0:Description>
							<xsl:choose>
								<xsl:when test="s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='NL']/C27304 != ''">
									<xsl:value-of select="s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='NL']/C27304"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='EN']/C27304 != ''">
											<xsl:value-of select="s0:IMDLoop1/s0:IMD_2[IMD01='E']/s0:C273_2[C27306='EN']/C27304"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="s0:IMDLoop1/s0:IMD_2[IMD01='E']/s0:C273_2/C27304"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</ns0:Description>
						<ns0:Description2>
							<xsl:choose>
								<xsl:when test="s0:IMDLoop1/s0:IMD_2[IMD01='E']/s0:C273_2[C27306='EN']/C27304 != ''">
									<xsl:value-of select="s0:IMDLoop1/s0:IMD_2[IMD01='E']/s0:C273_2[C27306='EN']/C27304"/>
									<!-- <xsl:value-of select="concat(s0:PIA_2[PIA01='1']/s0:C212_7[C21202='SA']/C21201, ' - ', s0:IMDLoop1/s0:IMD_2[IMD01='E']/s0:C273_2[C27306='EN']/C27304)"/> -->
								</xsl:when>
								<xsl:otherwise>
									<!-- <xsl:value-of select="concat(s0:PIA_2[PIA01='1']/s0:C212_7[C21202='SA']/C21201, ' - ', s0:IMDLoop1/s0:IMD_2[IMD01='E']/s0:C273_2/C27304)"/> -->
									<xsl:value-of select="s0:IMDLoop1/s0:IMD_2[IMD01='E']/s0:C273_2/C27304"/>
								</xsl:otherwise>
							</xsl:choose>
						</ns0:Description2>
						<ns0:ReservationMethod>3</ns0:ReservationMethod>
						<ns0:ExpirationDateMandatory>true</ns0:ExpirationDateMandatory>
						<ns0:SearchDescription>
							<xsl:choose>
								<xsl:when test="s0:IMDLoop1/s0:IMD_2[IMD01='E']/s0:C273_2[C27306='EN']/C27304 != ''">
									<!-- <xsl:value-of select="concat(s0:PIA_2[PIA01='1']/s0:C212_7[C21202='SA']/C21201, ' - ', s0:IMDLoop1/s0:IMD_2[IMD01='E']/s0:C273_2[C27306='EN']/C27304)"/> -->
									<xsl:value-of select="s0:IMDLoop1/s0:IMD_2[IMD01='E']/s0:C273_2[C27306='EN']/C27304"/>
								</xsl:when>
								<xsl:otherwise>
									<!-- <xsl:value-of select="concat(s0:PIA_2[PIA01='1']/s0:C212_7[C21202='SA']/C21201, ' - ', s0:IMDLoop1/s0:IMD_2[IMD01='E']/s0:C273_2/C27304)"/> -->
									<xsl:value-of select="s0:IMDLoop1/s0:IMD_2[IMD01='E']/s0:C273_2/C27304"/>
								</xsl:otherwise>
							</xsl:choose>
						</ns0:SearchDescription>

						<xsl:if test="s0:FTX[FTX01='ZZZ']/ns0:C108/C10804!=''">
							<ns0:CountryofOriginCode>
								<xsl:value-of select="s0:FTX[FTX01='ZZZ']/ns0:C108/C10804"/>
							</ns0:CountryofOriginCode>
						</xsl:if>

						<ns0:BaseUnitofMeasure>
							<xsl:text>CRT</xsl:text>
						</ns0:BaseUnitofMeasure>

						<ns0:Status>
							<xsl:text>1</xsl:text>
						</ns0:Status>

						<ns0:CarrierTypeCodeReceipt>
							<xsl:text>EURO</xsl:text>
						</ns0:CarrierTypeCodeReceipt>

						<ns0:CarrierTypeCodeShipment>
							<xsl:text>EURO</xsl:text>
						</ns0:CarrierTypeCodeShipment>

						<ns0:UnitofMeasureatReceipt>
							<xsl:text>CRT</xsl:text>
						</ns0:UnitofMeasureatReceipt>

						<ns0:UnitofMeasureatShipment>
							<xsl:text>CRT</xsl:text>
						</ns0:UnitofMeasureatShipment>

						<ns0:UnitofMeasureatStorage>
							<xsl:text>CRT</xsl:text>
						</ns0:UnitofMeasureatStorage>

						<ns0:UnitofMeasureatOrdering>
							<xsl:text>CRT</xsl:text>
						</ns0:UnitofMeasureatOrdering>

						<ns0:ConditionatReceipt>
							<xsl:text>BEVROREN</xsl:text>
						</ns0:ConditionatReceipt>

						<ns0:ConditionatShipment>
							<xsl:text>BEVROREN</xsl:text>
						</ns0:ConditionatShipment>

						<ns0:ConditionatStorage>
							<xsl:text>BEVROREN</xsl:text>
						</ns0:ConditionatStorage>

						<ns0:ReservationMethodBulk>
							<xsl:text>METHOD_1</xsl:text>
						</ns0:ReservationMethodBulk>

						<ns0:BatchNos>
							<xsl:text>0</xsl:text>
						</ns0:BatchNos>

						<ns0:SelectionCarrier>
							<xsl:text>0</xsl:text>
						</ns0:SelectionCarrier>

						<ns0:OrderPickType>
							<xsl:text>0</xsl:text>
						</ns0:OrderPickType>

						<ns0:BaseUnitofMeasure>
							<xsl:text>CRT</xsl:text>
						</ns0:BaseUnitofMeasure>

						<ns0:Status>
							<xsl:text>1</xsl:text>
						</ns0:Status>

						<!-- <ns0:TemplateName>
                            <xsl:text>CUSTITEM</xsl:text>
                        </ns0:TemplateName> -->

						<ns0:ItemCategoryCode>
							<xsl:text>GROEPD</xsl:text>
						</ns0:ItemCategoryCode>

						<ns0:ExtBatchNoMandatoryPost>
							<xsl:text>true</xsl:text>
						</ns0:ExtBatchNoMandatoryPost>

						<ns0:ExpirationDateMandatory>
							<xsl:text>true</xsl:text>
						</ns0:ExpirationDateMandatory>

						<ns0:InitialCarrierStatusCode>
							<xsl:text>90-GEBLOKKEERD</xsl:text>
						</ns0:InitialCarrierStatusCode>

						<ns0:UnitOfMeasures>
							<ns0:UnitOfMeasure>
								<xsl:choose>
									<xsl:when test="$QtyBulkTU = 'BLK'">
										<ns0:Code>
											<xsl:text>CRT</xsl:text>
										</ns0:Code>

										<ns0:QtyperUnitofMeasure>
											<!-- <xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:QTYLoop1/s0:QTY_2/s0:C186_2/C18602" /> -->
											<xsl:text>1</xsl:text>
										</ns0:QtyperUnitofMeasure>

										<ns0:EANCode>
											<xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=1]/s0:LIN/s0:C212_6/C21201" />
										</ns0:EANCode>

										<ns0:NetWeight>
											<xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:QTYLoop1/s0:QTY_2/s0:C186_2/C18602" />
										</ns0:NetWeight>

										<ns0:GrossWeight>
											<xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:QTYLoop1/s0:QTY_2/s0:C186_2/C18602" />
										</ns0:GrossWeight>

										<!-- <xsl:if test="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:MEA_2[s0:C502_3/C50201 ='AAA']/s0:C174_2/C17402!=''">
                                             <ns0:NetWeight>
                                             <xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:MEA_2[s0:C502_3/C50201 ='AAA']/s0:C174_2/C17402" />
                                             </ns0:NetWeight>
                                             </xsl:if> -->

										<!-- <xsl:if test="//s0:LINLoop1[s0:LIN/LIN01=1]/s0:MEA_2[s0:C502_3/C50201 ='AAB']/s0:C174_2/C17402!=''">
                                             <ns0:GrossWeight>
                                             <xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=1]/s0:MEA_2[s0:C502_3/C50201 ='AAB']/s0:C174_2/C17402" />
                                             </ns0:GrossWeight>
                                             </xsl:if> -->



										<!-- <xsl:if test="//s0:LINLoop1[s0:LIN/LIN01=1]/s0:MEA_2[s0:C502_3/C50201 ='HT']/s0:C174_2/C17402!=''">
                                             <ns0:Height>
                                             <xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=1]/s0:MEA_2[s0:C502_3/C50201 ='HT']/s0:C174_2/C17402" />
                                             </ns0:Height>
                                             </xsl:if> -->

										<!-- <xsl:if test="//s0:LINLoop1[s0:LIN/LIN01=1]/s0:MEA_2[s0:C502_3/C50201 ='DT']/s0:C174_2/C17402!=''">
                                             <ns0:Length>
                                             <xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=1]/s0:MEA_2[s0:C502_3/C50201 ='DT']/s0:C174_2/C17402" />
                                             </ns0:Length>
                                             </xsl:if> -->

										<!-- <xsl:if test="//s0:LINLoop1[s0:LIN/LIN01=1]/s0:MEA_2[s0:C502_3/C50201 ='WT']/s0:C174_2/C17402!=''">
                                             <ns0:Width>
                                             <xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=1]/s0:MEA_2[s0:C502_3/C50201 ='WT']/s0:C174_2/C17402" />
                                             </ns0:Width>
                                             </xsl:if> -->
									</xsl:when>

									<!-- TU -->
									<xsl:otherwise>
										<!-- CRT -->
										<ns0:Code>
											<xsl:text>CRT</xsl:text>
										</ns0:Code>
										<ns0:QtyperUnitofMeasure>
											<!-- <xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:QTYLoop1/s0:QTY_2/s0:C186_2/C18602" /> -->
											<xsl:text>1</xsl:text>
										</ns0:QtyperUnitofMeasure>
										<ns0:EANCode>
											<xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:LIN/s0:C212_6/C21201" />
										</ns0:EANCode>

										<xsl:if test="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:MEA_2[s0:C502_3/C50201 ='AAA']/s0:C174_2/C17402!=''">
											<ns0:NetWeight>
												<xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:MEA_2[s0:C502_3/C50201 ='AAA']/s0:C174_2/C17402" />
											</ns0:NetWeight>
										</xsl:if>

										<xsl:if test="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:MEA_2[s0:C502_3/C50201 ='AAB']/s0:C174_2/C17402!=''">
											<ns0:GrossWeight>
												<xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:MEA_2[s0:C502_3/C50201 ='AAB']/s0:C174_2/C17402" />
											</ns0:GrossWeight>
										</xsl:if>

										<xsl:if test="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:MEA_2[s0:C502_3/C50201 ='HT']/s0:C174_2/C17402!=''">
											<ns0:Height>
												<xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:MEA_2[s0:C502_3/C50201 ='HT']/s0:C174_2/C17402" />
											</ns0:Height>
										</xsl:if>

										<xsl:if test="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:MEA_2[s0:C502_3/C50201 ='DT']/s0:C174_2/C17402!=''">
											<ns0:Length>
												<xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:MEA_2[s0:C502_3/C50201 ='DT']/s0:C174_2/C17402" />
											</ns0:Length>
										</xsl:if>

										<xsl:if test="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:MEA_2[s0:C502_3/C50201 ='WT']/s0:C174_2/C17402!=''">
											<ns0:Width>
												<xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:MEA_2[s0:C502_3/C50201 ='WT']/s0:C174_2/C17402" />
											</ns0:Width>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>

								<ns0:UnitOfMeasureCarriers>
									<ns0:UnitOfMeasureCarrier>

										<ns0:CarrierTypeCode>EURO</ns0:CarrierTypeCode>
										<ns0:QtyperUOMCode>
											<xsl:value-of select="//s0:LINLoop1[s0:QTYLoop1/s0:QTY_2/s0:C186_2/C18603 = 'TU']/s0:QTYLoop1/s0:QTY_2/s0:C186_2/C18602" />
										</ns0:QtyperUOMCode>

									</ns0:UnitOfMeasureCarrier>
								</ns0:UnitOfMeasureCarriers>

							</ns0:UnitOfMeasure>
						</ns0:UnitOfMeasures>
					</ns0:CustomerItem>
				</xsl:for-each>
			</ns0:CustomerItems>
		</ns0:Message>
	</xsl:template>
</xsl:stylesheet>