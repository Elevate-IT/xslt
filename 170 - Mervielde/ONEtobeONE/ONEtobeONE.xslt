<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:soapenv="http://www.w3.org/2003/05/soap-envelope"
                xmlns:dep="http://interfacing.onetobeone.com/depot"
                xmlns:wsdl="http://interfacing.onetobeone.com/wsdltypes"
                xmlns:heat="http://interfacing.onetobeone.com/depot/heating"
                xmlns:gen="http://interfacing.onetobeone.com/generictypes"
                exclude-result-prefixes="dep wsdl heat gen">

    <!-- Output SOAP Envelope with namespaces -->
    <xsl:output method="xml" indent="yes"/>

    <!-- Match root element -->
    <xsl:template match="/">
        <Envelope xmlns="http://www.w3.org/2003/05/soap-envelope">
            <Body>
                <createHeatingOrderRequest xmlns="http://interfacing.onetobeone.com/depot">
                    <authentication>
                        <sourceSystemCode xmlns="http://interfacing.onetobeone.com/wsdltypes">TRICS</sourceSystemCode>
                        <username xmlns="http://interfacing.onetobeone.com/wsdltypes">merv-bol</username>
                        <password xmlns="http://interfacing.onetobeone.com/wsdltypes">password</password>
                    </authentication>
                    <heatingOrder>
                        <sourceSystemId xmlns="http://interfacing.onetobeone.com/depot/heating">2086</sourceSystemId>
                        <client xmlns="http://interfacing.onetobeone.com/depot/heating">
                            <reference xmlns="http://interfacing.onetobeone.com/generictypes">WEM</reference>
                        </client>
                        <contractor xmlns="http://interfacing.onetobeone.com/depot/heating">
                            <reference xmlns="http://interfacing.onetobeone.com/generictypes">MERV</reference>
                        </contractor>
                        <clientReference xmlns="http://interfacing.onetobeone.com/depot/heating">clientRef</clientReference>
                        <deadline xmlns="http://interfacing.onetobeone.com/depot/heating">2024-07-11T07:11:23Z</deadline>
                        <trailerOrContainer xmlns="http://interfacing.onetobeone.com/depot/heating">
                            <registrationCode>RegistrationCode</registrationCode>
                            <referenceOwner>refOwner</referenceOwner>
                            <countryOfRegistration>NL</countryOfRegistration>
                            <type>TRAILER</type>
                            <compartments>
                                <compartment>
                                    <compartmentNumber>1</compartmentNumber>
                                    <volumeLiters>5000</volumeLiters>
                                    <manholes>2</manholes>
                                </compartment>
                                <compartment>
                                    <compartmentNumber>2</compartmentNumber>
                                    <volumeLiters>10000</volumeLiters>
                                    <manholes>4</manholes>
                                </compartment>
                            </compartments>
                        </trailerOrContainer>
                        <storageLocation xmlns="http://interfacing.onetobeone.com/depot/heating">A1b</storageLocation>
                        <productCode xmlns="http://interfacing.onetobeone.com/depot/heating">CHOC</productCode>
                        <weightKg xmlns="http://interfacing.onetobeone.com/depot/heating">1000.0</weightKg>
                        <volumeLiters xmlns="http://interfacing.onetobeone.com/depot/heating">2000.0</volumeLiters>
                        <desiredTemperatureCelsius xmlns="http://interfacing.onetobeone.com/depot/heating">55.5</desiredTemperatureCelsius>
                        <maxPressureBar xmlns="http://interfacing.onetobeone.com/depot/heating">2.5</maxPressureBar>
                        <station xmlns="http://interfacing.onetobeone.com/depot/heating">
                            <code xmlns="http://interfacing.onetobeone.com/generictypes">Kulhman hot water</code>
                            <description xmlns="http://interfacing.onetobeone.com/generictypes">testDescr</description>
                        </station>
                        <heatingProcedure xmlns="http://interfacing.onetobeone.com/depot/heating">Kosher food</heatingProcedure>
                        <nextAction xmlns="http://interfacing.onetobeone.com/depot/heating">HANDLING_OUT</nextAction>
                        <numberOfSeals xmlns="http://interfacing.onetobeone.com/depot/heating">8</numberOfSeals>
                        <comment xmlns="http://interfacing.onetobeone.com/depot/heating">Test comment</comment>
                        <compartments xmlns="http://interfacing.onetobeone.com/depot/heating">
                            <compartment>
                                <compartmentNumber>1</compartmentNumber>
                                <productCode>CHOC</productCode>
                            </compartment>
                            <compartment>
                                <compartmentNumber>2</compartmentNumber>
                                <productCode>FAT</productCode>
                            </compartment>
                        </compartments>
                        <connectInstruction xmlns="http://interfacing.onetobeone.com/depot/heating">Connect instruction</connectInstruction>
                        <disconnectInstruction xmlns="http://interfacing.onetobeone.com/depot/heating">Disconnect construction</disconnectInstruction>
                    </heatingOrder>
                </createHeatingOrderRequest>
            </Body>
        </Envelope>
    </xsl:template>

</xsl:stylesheet>
