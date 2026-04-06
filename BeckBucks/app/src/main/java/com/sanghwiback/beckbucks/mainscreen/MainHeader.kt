package com.sanghwiback.beckbucks.mainscreen

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Preview(showBackground = true)
@Composable
fun MainHeader(modifier: Modifier = paddingModifier) {
    Column(modifier.padding(top = 16.dp)) {
        Text(
            text = "테스터님, 나를 위한\n다정한 시간을 가져보아요",
            fontSize = 22.sp,
            fontWeight = FontWeight.Bold,
            lineHeight = 32.sp,
            color = TextPrimary
        )
    }
}
