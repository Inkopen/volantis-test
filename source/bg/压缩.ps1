# 找到现有的 webp 文件名中的最大数字
$existing = Get-ChildItem *.webp |
    Where-Object { $_.BaseName -match '^\d+$' } |
    ForEach-Object { [int]$_.BaseName }

if ($existing.Count -gt 0) {
    $n = ($existing | Measure-Object -Maximum).Maximum + 1
} else {
    $n = 1
}

# 处理新的 jpg 和 png
Get-ChildItem *.jpg, *.png | Sort-Object Name | ForEach-Object {
    $output = "$n.webp"
    cwebp -q 80 $_.FullName -o $output

    if (Test-Path $output) {
        Remove-Item $_.FullName
    }

    $n++
}