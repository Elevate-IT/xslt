<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl MyScript"
    xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:key name="Group-by-DelAddress" match="//DELIVERY" use="CallOffData/DeliveryAddressId" />

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/">
    <xsl:apply-templates select="DESPATCH"/>
  </xsl:template>

  <xsl:template match="DESPATCH">
    <xsl:copy>
      <xsl:apply-templates select="UNH"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="UNH">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>

    <xsl:for-each select="//DELIVERY[count(. | key('Group-by-DelAddress', CallOffData/DeliveryAddressId)[1]) = 1]">
      <xsl:variable name="LineKey" select="CallOffData/DeliveryAddressId" />
      <xsl:if test="CallOffData/DeliveryAddressId != ''">
        <xsl:value-of select="MyScript:SetMinRunSeqId('0')" />
        <xsl:for-each select="key('Group-by-DelAddress', CallOffData/DeliveryAddressId)/DespatchData">
          <xsl:value-of select="MyScript:SetMinRunSeqId(CarrierRunSeqId)" />
        </xsl:for-each>

        <xsl:value-of select="MyScript:AddToMinRunSeqIdList()" />
      </xsl:if>
    </xsl:for-each>

    <xsl:for-each select="//DELIVERY[count(. | key('Group-by-DelAddress', CallOffData/DeliveryAddressId)[1]) = 1]">
      <xsl:variable name="LineKey" select="CallOffData/DeliveryAddressId" />
      <xsl:variable name="Counter" select="MyScript:GetCounter(1)"/>
      <xsl:if test="CallOffData/DeliveryAddressId != ''">
        <xsl:value-of select="MyScript:SetMinRunSeqId('0')" />
        <xsl:value-of select="MyScript:SetMaxRunSeqId('0')" />
        <xsl:for-each select="key('Group-by-DelAddress', CallOffData/DeliveryAddressId)/DespatchData">
          <xsl:value-of select="MyScript:SetMinRunSeqId(CarrierRunSeqId)" />
          <xsl:value-of select="MyScript:SetMaxRunSeqId(CarrierRunSeqId)" />
        </xsl:for-each>

        <xsl:copy>
          <xsl:for-each select="//CallOffData[DeliveryAddressId = $LineKey]">
            <xsl:variable name="Counter2" select="MyScript:GetCounter2(1)"/>
            <xsl:variable name="LoadSeq" select="MyScript:GetLoadSeq(count(//DELIVERY[count(. | key('Group-by-DelAddress', CallOffData/DeliveryAddressId)[1]) = 1]))"/>
            <xsl:variable name="FirstLoadCarRunSeq" select="MyScript:GetMaxRunSeqId()"/>
            <xsl:copy>
              <DeliveryId>
                <xsl:value-of select="$Counter" />
              </DeliveryId>
              <DeliveryLineId>
                <xsl:value-of select="$Counter2" />
              </DeliveryLineId>
              <LoadSeq>
                <xsl:value-of select="$LoadSeq" />
              </LoadSeq>
              <FirstLoadCarRunSeq>
                <xsl:value-of select="$FirstLoadCarRunSeq" />
              </FirstLoadCarRunSeq>
              <xsl:apply-templates select="@* | node()"/>
            </xsl:copy>
            <xsl:apply-templates select="../DespatchData">
              <xsl:with-param name="Counter" select="$Counter" />
              <xsl:with-param name="Counter2" select="$Counter2" />
              <xsl:with-param name="LoadSeq" select="$LoadSeq" />
              <xsl:with-param name="FirstLoadCarRunSeq" select="$FirstLoadCarRunSeq" />
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:copy>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="DespatchData">
    <xsl:param name="Counter"/>
    <xsl:param name="Counter2"/>
    <xsl:param name="LoadSeq"/>
    <xsl:param name="FirstLoadCarRunSeq"/>
    <xsl:copy>
      <DeliveryId>
        <xsl:value-of select="$Counter" />
      </DeliveryId>
      <DeliveryLineId>
        <xsl:value-of select="$Counter2" />
      </DeliveryLineId>
      <LoadSeq>
        <xsl:value-of select="$LoadSeq" />
      </LoadSeq>
      <FirstLoadCarRunSeq>
        <xsl:value-of select="$FirstLoadCarRunSeq" />
      </FirstLoadCarRunSeq>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[
      public int Counter;
      public int Counter2;
      public int MinRunSeqId;
      public int MaxRunSeqId;
      public Collections.Generic.List<int> MinRunSeqIdList = new Collections.Generic.List<int>();
      
      public string GetCounter(bool increment) {
        if (increment)
          Counter += 1;
          
        return Counter.ToString();
      }
      
      public string GetCounter2(bool increment) {
        if (increment)
          Counter2 += 1;
          
        return Counter2.ToString();
      }
      
      public void SetMinRunSeqId(string RunSeqId) {
        if (RunSeqId != "") {
          if (MinRunSeqId == 0)
            MinRunSeqId = Int32.Parse(RunSeqId);
        
          if (Int32.Parse(RunSeqId) < MinRunSeqId)
            MinRunSeqId = Int32.Parse(RunSeqId);
        }
      }
      
      public void SetMaxRunSeqId(string RunSeqId) {
        if (RunSeqId != "") {
          if (Int32.Parse(RunSeqId) == 0)
            MaxRunSeqId = Int32.Parse(RunSeqId);
        
          if (Int32.Parse(RunSeqId) > MaxRunSeqId)
            MaxRunSeqId = Int32.Parse(RunSeqId);
        }
      }
      
      public string GetLoadSeq(string DeliveryCount) {
        return (Int32.Parse(DeliveryCount) - MinRunSeqIdList.IndexOf(MinRunSeqId)).ToString();
      }
      
      public string GetMaxRunSeqId() {
        return MaxRunSeqId.ToString();
      }
      
      public void AddToMinRunSeqIdList() {
        MinRunSeqIdList.Add(MinRunSeqId);
        MinRunSeqIdList.Sort();
      }
    ]]>
  </msxsl:script>
</xsl:stylesheet>
